// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/config;
import ballerina/io;
import ballerinax/java.jdbc;

jdbc:Client testDB = new({
      url: config:getAsString("database.mysql.test.jdbc.url"),
      username: config:getAsString("database.mysql.test.jdbc.username"),
      password: config:getAsString("database.mysql.test.jdbc.password"),
      dbOptions: { clobberStreamingResults: true }
});

type Result record {
   int id;
   string val;
};

type ResultAutoGen record {
  int id;
  string val;
  string autogen;
};

function testSelectFullIterateUpdate() returns [int, int, int, int] {
    int retryCount = 0;
    int iterationCount = 0;
    int firstUpdateRet = -1;
    int secondUpdateRet = -1;
    transaction {
        var selectRet1 = testDB->select("SELECT * FROM TRX_TEST WHERE ID = ?", Result, 1);
        if (selectRet1 is table<record{}>) {
           foreach var rec in selectRet1 {
              iterationCount = iterationCount + 1;
           }
        }
        var updateRet1 = testDB->update("INSERT INTO TRX_TEST VALUES(?, ?)", 2, "Dummy");
        if (updateRet1 is jdbc:UpdateResult) {
            firstUpdateRet = updateRet1.updatedRowCount;
        }
        var updateRet2 = testDB->update("INSERT INTO TRX_TEST VALUES(?, ?)", 3, "Dummy");
        if (updateRet2 is jdbc:UpdateResult) {
            secondUpdateRet = updateRet2.updatedRowCount;
        }
    } onretry {
        retryCount = retryCount + 1;
    }
    return [retryCount, iterationCount, firstUpdateRet, secondUpdateRet];
}

function testSelectPartialIterateUpdate() returns [int, int, int, int] {
    int retryCount = 0;
    int iterationCount = 0;
    int firstUpdateRet = -1;
    int secondUpdateRet = -1;
    transaction {
        var selectRet1 = testDB->select("SELECT * FROM TRX_TEST WHERE ID = ?", Result, 1);
        if (selectRet1 is table<record{}>) {
            while (selectRet1.hasNext()) {
                Result rs = <Result> selectRet1.getNext();
                iterationCount = iterationCount + 1;
                break;
            }
        }
        var updateRet1 = testDB->update("INSERT INTO TRX_TEST VALUES(?, ?)", 4, "Dummy");
        if (updateRet1 is jdbc:UpdateResult) {
            firstUpdateRet = updateRet1.updatedRowCount;
        }
        var updateRet2 = testDB->update("INSERT INTO TRX_TEST VALUES(?, ?)", 5, "Dummy");
        if (updateRet2 is jdbc:UpdateResult) {
            secondUpdateRet = updateRet2.updatedRowCount;
        }
    } onretry {
        retryCount = retryCount + 1;
    }
    return [retryCount, iterationCount, firstUpdateRet, secondUpdateRet];
}

function testSelectCloseUpdate() returns [int, int, int] {
    int retryCount = 0;
    int firstUpdateRet = -1;
    int secondUpdateRet = -1;
    transaction {
        var selectRet1 = testDB->select("SELECT * FROM TRX_TEST WHERE ID = ?", Result, 1);
        if (selectRet1 is table<record{}>) {
            selectRet1.close();
        }
        var updateRet1 = testDB->update("INSERT INTO TRX_TEST VALUES(?, ?)", 6, "Dummy");
        if (updateRet1 is jdbc:UpdateResult) {
            firstUpdateRet = updateRet1.updatedRowCount;
        }
        var updateRet2 = testDB->update("INSERT INTO TRX_TEST VALUES(?, ?)", 7, "Dummy");
        if (updateRet2 is jdbc:UpdateResult) {
            secondUpdateRet = updateRet2.updatedRowCount;
        }
    } onretry {
        retryCount = retryCount + 1;
    }
    return [retryCount, firstUpdateRet, secondUpdateRet];
}

function testUpdateSelectPartialIterateUpdate() returns [int, int, int, int] {
    int retryCount = 0;
    int iterationCount = 0;
    int firstUpdateRet = -1;
    int secondUpdateRet = -1;
    transaction {
        var updateRet1 = testDB->update("INSERT INTO TRX_TEST VALUES(?, ?)", 8, "Dummy");
        if (updateRet1 is jdbc:UpdateResult) {
            firstUpdateRet = updateRet1.updatedRowCount;
        }
        var selectRet1 = testDB->select("SELECT * FROM TRX_TEST WHERE ID = ?", Result, 1);
        if (selectRet1 is table<record{}>) {
            while (selectRet1.hasNext()) {
                Result rs = <Result> selectRet1.getNext();
                iterationCount = iterationCount + 1;
                break;
            }
        }
        var updateRet2 = testDB->update("INSERT INTO TRX_TEST VALUES(?, ?)", 9, "Dummy");
        if (updateRet2 is jdbc:UpdateResult) {
            secondUpdateRet = updateRet2.updatedRowCount;
        }
    } onretry {
        retryCount = retryCount + 1;
    }
    return [retryCount, iterationCount, firstUpdateRet, secondUpdateRet];
}

function testUpdateWithGeneratedKeysSelectFullIterate() returns @tainted [int, string, int, int] {
    int retryCount = 0;
    string autoGenVal = "";
    int firstUpdateRet = -1;
    int secondUpdateRet = -1;
    transaction {
        var updateRet1 = testDB->update("INSERT INTO TRX_TEST_AUTO_GEN_KEY (ID, VAL) VALUES(?, ?)", 10, "Dummy");
        if (updateRet1 is jdbc:UpdateResult) {
            firstUpdateRet = updateRet1.updatedRowCount;
        } else {
            error e = updateRet1;
            io:println(e.detail()["message"]);
        }
        var selectRet1 = testDB->select("SELECT * FROM TRX_TEST_AUTO_GEN_KEY WHERE ID = ?", ResultAutoGen, 10);
        if (selectRet1 is table<record{}>) {
            while (selectRet1.hasNext()) {
                ResultAutoGen rs = <ResultAutoGen> selectRet1.getNext();
                autoGenVal = rs.autogen;
            }
        } else {
           error e = selectRet1;
           io:println(e.detail()["message"]);
        }
        var updateRet2 = testDB->update("INSERT INTO TRX_TEST VALUES(?, ?)", 10, "Dummy");
        if (updateRet2 is jdbc:UpdateResult) {
            secondUpdateRet = updateRet2.updatedRowCount;
        } else {
            error e = updateRet2;
            io:println(e.detail()["message"]);
        }
    } onretry {
        retryCount = retryCount + 1;
    }
    return [retryCount, autoGenVal, firstUpdateRet, secondUpdateRet];
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}

