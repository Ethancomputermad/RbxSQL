RbxSQL
======

Query an SQL Server from Lua!


Getting started
======

To start, put RbxSQL.lua in its own script, then for any script you wish to use RBXSql from, enter the following at the start
```
RbxSQL={} repeat wait() until _G.RbxSQL _G.RbxSQL()
```

Documentation
======

* = Optional

RbxSQL.connect([string] hostname, [string] username, [string] password, *[string] database, *[string] port, *[string] socket)

RbxSQL.query([connection] RbxSQL Connection, [string] query)

Example
======
This script would create a table called hello in database lua, with one index called world, and then add mark to the table

```
RbxSQL={} repeat wait() until _G.RbxSQL _G.RbxSQL()

connection=RbxSQL.connect('123.456.78,9','Administrator','12345678','lua')

RbxSQL.query(connection,'CREATE TABLE hello (world varchar(10) )')

RbxSQL.query(connection,'INSERT INTO hello (world) VALUES ("mark")')

connection:disconnect()
```

Support me
======
https://streamtip.com/t/rbxethan

Notice (Legal stuff)
======
Copyright(C) Ethan Sweet 2014, All Rights Reserved. Service may be terminated at any time. Permission to use the source below and service may be withdrawn at any time for any reason.
