<cfscript>
  app_code = "ThirdPartyInternalControlsPolicySelfAssessment_V3a";
  request.app_niceName = "DBOE-ORAP TPICPSA";

  // Get the name of the server and strip off '.ihs.gov' to get the base name. Possible values of the base server name are
  // wwwdev., www2dev., wwwstage., www2stage., www., www2., and my.

  serverName = cgi.server_name;
  request.serverName = serverName;
  baseName = lcase(left(serverName,Find(".",serverName,1)));


  /* create dynamic NAME attribute for CFAPPLICATION:
     app_code + _ +  serverName to yield values such as:
     RSC_home, RSC_homestage, RSC_home2, RSC_home2stage, RSC_homedev, RSC_www, RSC_www2, ... */
  app_name=lcase(app_code&"_"&ListFirst(serverName,"."));
  request.app_timeoutDays  = 10;
  request.app_timeoutHours = 10;
  request.app_timeoutMins  = 5;
  request.app_timeoutSecs  = 5;
</cfscript>

<cfapplication
name               = "#app_name#"
applicationTimeout = "#CreateTimeSpan(request.app_timeoutDays,0,0,0)#"
sessionTimeout     = "#CreateTimeSpan(request.app_timeoutDays,request.app_timeoutHours,0,0)#"
sessionManagement  = "yes"
scriptProtect="Form,URL,Cookie">