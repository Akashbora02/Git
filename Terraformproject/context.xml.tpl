<Context>
    <WatchedResource>WEB-INF/web.xml</WatchedResource>
    <WatchedResource>${catalina.base}/conf/web.xml</WatchedResource>
    <Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource" maxTotal="100" maxIdle="30" maxWaitMillis="10000" username="admin" password="${db_password}" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://${db_endpoint}:3306/studentapp"/>
</Context>