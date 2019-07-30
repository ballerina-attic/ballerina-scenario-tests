INSERT INTO SELECT_UPDATE_TEST_NUMERIC_TYPES
VALUES(1, 32767, 9223372036854775807, 255, 1, 2147483647, 10.05, 1.051, 922337203685477.5807, 214748.3647);
/
INSERT INTO SELECT_UPDATE_TEST_NUMERIC_TYPES
VALUES(2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
/
INSERT INTO SELECT_UPDATE_TEST_FLOAT_TYPES VALUES(1, 123.45678, 123456789012345678901234567890);
/
INSERT INTO SELECT_UPDATE_TEST_FLOAT_TYPES VALUES(2, null, null);
/
INSERT INTO SELECT_UPDATE_TEST_STRING_TYPES VALUES(1, 'ABCD', 'SQL Server VARCHAR', 'This is test message', N'ああ', N'ありがとうございまし', 'Text');
/
INSERT INTO SELECT_UPDATE_TEST_STRING_TYPES VALUES(2, NULL , NULL, NULL, NULL, NULL, NULL);
/
INSERT INTO SELECT_UPDATE_TEST_COMPLEX_TYPES VALUES(1, cast('Binary Column' as BINARY), cast('varbinary Column' as VARBINARY), cast('0x89504E470D0A1A0A00000' as IMAGE));
/
INSERT INTO SELECT_UPDATE_TEST_COMPLEX_TYPES VALUES(2, NULL, NULL, NULL);
/
INSERT INTO SELECT_UPDATE_TEST_DATETIME_TYPES VALUES(1, CAST('2007-05-08 12:35:29.1234567 +12:15' AS date), CAST('2007-05-08 12:35:29.1234567 +12:15' AS datetimeoffset),
CAST('2007-05-08 12:35:29.123' AS datetime), CAST('2007-05-08 12:35:29.1234567 +12:15' AS datetime2(7)), CAST('2007-05-08 12:35:29.123' AS smalldatetime), CAST('2007-05-08 12:35:29.1234567 +12:15' AS time(7)));
/
INSERT INTO SELECT_UPDATE_TEST_DATETIME_TYPES VALUES(2, NULL, NULL, NULL, NULL, NULL, NULL);
/