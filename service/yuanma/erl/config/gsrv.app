%% auther: xyao   
%% email: jiexiaowen@gmail.com   
%% date: 2010.06.12
  
{   
    application, gsrv,
    [   
        {description, "This is game server."},   
        {vsn, "1.0a"},   
        {modules,[gsrv]},
        {registered, [gsrv_app]},
        {applications, [kernel, stdlib, sasl]},   
        {mod, {gsrv_app, []}},
        {start_phases, []},
		{env,[ 
                {server, "T1"}
           ]
        }
    ]   
}.    
 
%% File end.  
