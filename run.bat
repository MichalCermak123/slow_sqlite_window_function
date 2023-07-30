set QUERY=WITH T(Id, ContId) AS(SELECT ROWID, row_number() OVER(ORDER BY ID) -1 FROM TestTable) UPDATE TestTable SET ContId=(SELECT ContId FROM T WHERE TestTable.ROWID=T.Id)
set QUERY_PLAN=EXPLAIN QUERY PLAN %QUERY%

copy /y test_db.db test_db_3410100.db

sqlite-tools-win32-x86-3410100\sqlite3.exe test_db_3410100.db "%QUERY_PLAN%"
echo Working (3410100) version start - %TIME%
sqlite-tools-win32-x86-3410100\sqlite3.exe test_db_3410100.db -stats "%QUERY%"
echo Working (3410100) version finish - %TIME%

copy /y test_db.db test_db_3410200.db
sqlite-tools-win32-x86-3410200\sqlite3.exe test_db_3410200.db "%QUERY_PLAN%"
echo First slow (3410200) version start - %TIME%
sqlite-tools-win32-x86-3410200\sqlite3.exe test_db_3410200.db -stats "%QUERY%"
echo First slow (3410200) version finish - %TIME%

copy /y test_db.db test_db_3420000.db
sqlite-tools-win32-x86-3420000\sqlite3.exe test_db_3420000.db "%QUERY_PLAN%"
echo Latest (3420000) version start - %TIME%
sqlite-tools-win32-x86-3420000\sqlite3.exe test_db_3420000.db -stats "%QUERY%"
echo Latest (3420000) version finish - %TIME%

sqlite-tools-win32-x86-3420000\sqldiff.exe test_db_3410100.db test_db_3410200.db
sqlite-tools-win32-x86-3420000\sqldiff.exe test_db_3410100.db test_db_3420000.db
