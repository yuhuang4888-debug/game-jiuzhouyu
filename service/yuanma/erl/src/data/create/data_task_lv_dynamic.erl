%%%---------------------------------------
%%% @Module  : data_task_lv_dynamic
%%% @Description:  任务动态任务内容
%%%---------------------------------------
-module(data_task_lv_dynamic).
-compile(export_all).
-include("task.hrl").


get_task_type(6)->
        #task_type{type=6,count=10,module_id=300,counter_id=2,finish_cost=[{2,36010001,10}]};
get_task_type(7)->
        #task_type{type=7,count=20,module_id=300,counter_id=1,finish_cost=[{2,36010001,10}]};
get_task_type(9)->
        #task_type{type=9,count=10,module_id=300,counter_id=3,finish_cost=[]};
get_task_type(_) ->
    [].

get_type_task_id(6,Lv) when Lv >= 65 andalso Lv =< 99->
        #task_lv_dynamic_id{type=6,slv=65,elv=99,task_ids=[500100,500101,500102,500103,500104,500105,500106,500107]};
get_type_task_id(6,Lv) when Lv >= 100 andalso Lv =< 105->
        #task_lv_dynamic_id{type=6,slv=100,elv=105,task_ids=[500200,500201,500202,500203,500204,500205,500206,500207]};
get_type_task_id(6,Lv) when Lv >= 106 andalso Lv =< 159->
        #task_lv_dynamic_id{type=6,slv=106,elv=159,task_ids=[500300,500301,500302,500303,500304,500305,500306,500307]};
get_type_task_id(6,Lv) when Lv >= 160 andalso Lv =< 180->
        #task_lv_dynamic_id{type=6,slv=160,elv=180,task_ids=[500400,500401,500402,500403,500404,500405,500406,500407]};
get_type_task_id(6,Lv) when Lv >= 181 andalso Lv =< 239->
        #task_lv_dynamic_id{type=6,slv=181,elv=239,task_ids=[500500,500501,500502,500503,500504,500505,500506,500507]};
get_type_task_id(6,Lv) when Lv >= 240 andalso Lv =< 299->
        #task_lv_dynamic_id{type=6,slv=240,elv=299,task_ids=[500600,500601,500602,500603,500604,500605,500606,500607,500700,500701,500702,500704,500705,500706]};
get_type_task_id(6,Lv) when Lv >= 300 andalso Lv =< 379->
        #task_lv_dynamic_id{type=6,slv=300,elv=379,task_ids=[500703,500707,500800,500801,500802,500804,500805,500806]};
get_type_task_id(6,Lv) when Lv >= 380 andalso Lv =< 489->
        #task_lv_dynamic_id{type=6,slv=380,elv=489,task_ids=[500803,500806,500807,500900,500901,500902,500903,500904,500905,500906,501101,501105]};
get_type_task_id(6,Lv) when Lv >= 490 andalso Lv =< 569->
        #task_lv_dynamic_id{type=6,slv=490,elv=569,task_ids=[500907,501000,501001,501002,501003,501004,501005,501006,501007,501102,501103,501106]};
get_type_task_id(6,Lv) when Lv >= 570 andalso Lv =< 9999->
        #task_lv_dynamic_id{type=6,slv=570,elv=9999,task_ids=[501100,501104,501107,501200,501201,501202,501203,501204,501205,501206,501207,501300,501301,501302,501303,501304,501305,501306,501307]};
get_type_task_id(7,Lv) when Lv >= 65 andalso Lv =< 99->
        #task_lv_dynamic_id{type=7,slv=65,elv=99,task_ids=[400100,400101,400102,400103,400104,400105,400106,400107]};
get_type_task_id(7,Lv) when Lv >= 100 andalso Lv =< 105->
        #task_lv_dynamic_id{type=7,slv=100,elv=105,task_ids=[400200,400201,400202,400203,400204,400205,400206,400207]};
get_type_task_id(7,Lv) when Lv >= 106 andalso Lv =< 159->
        #task_lv_dynamic_id{type=7,slv=106,elv=159,task_ids=[400300,400301,400302,400303,400304,400305,400306,400307]};
get_type_task_id(7,Lv) when Lv >= 160 andalso Lv =< 180->
        #task_lv_dynamic_id{type=7,slv=160,elv=180,task_ids=[400400,400401,400402,400403,400404,400405,400406,400407]};
get_type_task_id(7,Lv) when Lv >= 181 andalso Lv =< 239->
        #task_lv_dynamic_id{type=7,slv=181,elv=239,task_ids=[400500,400501,400502,400503,400504,400505,400506,400507]};
get_type_task_id(7,Lv) when Lv >= 240 andalso Lv =< 299->
        #task_lv_dynamic_id{type=7,slv=240,elv=299,task_ids=[400600,400601,400602,400603,400604,400605,400606,400607,400700,400701,400702,400704,400705,400706]};
get_type_task_id(7,Lv) when Lv >= 300 andalso Lv =< 379->
        #task_lv_dynamic_id{type=7,slv=300,elv=379,task_ids=[400703,400707,400800,400801,400802,400804,400805,400806]};
get_type_task_id(7,Lv) when Lv >= 380 andalso Lv =< 489->
        #task_lv_dynamic_id{type=7,slv=380,elv=489,task_ids=[400803,400807,400900,400901,400902,400903,400904,400905,400906,400907,401102,401106]};
get_type_task_id(7,Lv) when Lv >= 490 andalso Lv =< 569->
        #task_lv_dynamic_id{type=7,slv=490,elv=569,task_ids=[401000,401001,401002,401003,401004,401005,401006,401007,401100,401103,401104,401107]};
get_type_task_id(7,Lv) when Lv >= 570 andalso Lv =< 9999->
        #task_lv_dynamic_id{type=7,slv=570,elv=9999,task_ids=[401101,401105,401200,401201,401202,401203,401204,401205,401206,401207,401300,401301,401302,401303,401304,401305,401306,401307]};
get_type_task_id(7,Lv) when Lv >= 1110 andalso Lv =< 159->
        #task_lv_dynamic_id{type=7,slv=1110,elv=159,task_ids=[400300,400301,400302,400303,400304,400305,400306,400307]};
get_type_task_id(9,12001) ->
        #task_lv_dynamic_id{type=9,slv=12001,elv=12001,task_ids=[900001,900002,900003,900004,900005,900006,900007,900008,900009,900010]};
get_type_task_id(9,12002) ->
        #task_lv_dynamic_id{type=9,slv=12002,elv=12002,task_ids=[900011,900012,900013,900014,900015,900016,900017,900018,900019,900020]};
get_type_task_id(9,12003) ->
        #task_lv_dynamic_id{type=9,slv=12003,elv=12003,task_ids=[900021,900022,900023,900024,900025,900026,900027,900028,900029,900030]};
get_type_task_id(10,Lv) when Lv >= 0 andalso Lv =< 420->
        #task_lv_dynamic_id{type=10,slv=0,elv=420,task_ids=[600001,600002,600003]};
get_type_task_id(10,Lv) when Lv >= 421 andalso Lv =< 999->
        #task_lv_dynamic_id{type=10,slv=421,elv=999,task_ids=[600011,600012,600013]};
get_type_task_id(_TaskType,_Lv) ->
    [].

get_type_task_dynamic(400100,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=400100,slv=65, elv=99,start_npc = 100212,end_npc = 0,scene = 10001,x = 488,y = 3770,content_type = 1,id = 10001016,num = 10};
get_type_task_dynamic(400101,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=400101,slv=65, elv=99,start_npc = 100204,end_npc = 0,scene = 10001,x = 5261,y = 1215,content_type = 1,id = 10001014,num = 10};
get_type_task_dynamic(400102,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=400102,slv=65, elv=99,start_npc = 100210,end_npc = 0,scene = 10001,x = 2803,y = 1563,content_type = 1,id = 10001015,num = 10};
get_type_task_dynamic(400103,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=400103,slv=65, elv=99,start_npc = 100212,end_npc = 0,scene = 10001,x = 488,y = 3770,content_type = 1,id = 10001016,num = 10};
get_type_task_dynamic(400104,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=400104,slv=65, elv=99,start_npc = 100212,end_npc = 0,scene = 10001,x = 5247,y = 2715,content_type = 11,id = 38101,num = 1};
get_type_task_dynamic(400105,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=400105,slv=65, elv=99,start_npc = 100204,end_npc = 0,scene = 10001,x = 5114,y = 1056,content_type = 11,id = 38102,num = 1};
get_type_task_dynamic(400106,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=400106,slv=65, elv=99,start_npc = 100210,end_npc = 0,scene = 10001,x = 1222,y = 3492,content_type = 11,id = 38103,num = 1};
get_type_task_dynamic(400107,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=400107,slv=65, elv=99,start_npc = 100212,end_npc = 0,scene = 10001,x = 1243,y = 1749,content_type = 11,id = 38104,num = 1};
get_type_task_dynamic(400200,Lv) when Lv >= 100 andalso Lv =< 105->
    #task_lv_dynamic_content{task_id=400200,slv=100, elv=105,start_npc = 100213,end_npc = 0,scene = 10001,x = 488,y = 3770,content_type = 1,id = 10001016,num = 15};
get_type_task_dynamic(400201,Lv) when Lv >= 100 andalso Lv =< 105->
    #task_lv_dynamic_content{task_id=400201,slv=100, elv=105,start_npc = 100215,end_npc = 0,scene = 10001,x = 1222,y = 3154,content_type = 1,id = 10001017,num = 15};
get_type_task_dynamic(400202,Lv) when Lv >= 100 andalso Lv =< 105->
    #task_lv_dynamic_content{task_id=400202,slv=100, elv=105,start_npc = 100218,end_npc = 0,scene = 10001,x = 1357,y = 1812,content_type = 1,id = 10001018,num = 15};
get_type_task_dynamic(400203,Lv) when Lv >= 100 andalso Lv =< 105->
    #task_lv_dynamic_content{task_id=400203,slv=100, elv=105,start_npc = 100220,end_npc = 0,scene = 10001,x = 984,y = 686,content_type = 1,id = 10001019,num = 15};
get_type_task_dynamic(400204,Lv) when Lv >= 100 andalso Lv =< 105->
    #task_lv_dynamic_content{task_id=400204,slv=100, elv=105,start_npc = 100213,end_npc = 0,scene = 10001,x = 5247,y = 2715,content_type = 11,id = 38101,num = 1};
get_type_task_dynamic(400205,Lv) when Lv >= 100 andalso Lv =< 105->
    #task_lv_dynamic_content{task_id=400205,slv=100, elv=105,start_npc = 100215,end_npc = 0,scene = 10001,x = 5114,y = 1056,content_type = 11,id = 38102,num = 1};
get_type_task_dynamic(400206,Lv) when Lv >= 100 andalso Lv =< 105->
    #task_lv_dynamic_content{task_id=400206,slv=100, elv=105,start_npc = 100218,end_npc = 0,scene = 10001,x = 1222,y = 3492,content_type = 11,id = 38103,num = 1};
get_type_task_dynamic(400207,Lv) when Lv >= 100 andalso Lv =< 105->
    #task_lv_dynamic_content{task_id=400207,slv=100, elv=105,start_npc = 100220,end_npc = 0,scene = 10001,x = 1243,y = 1749,content_type = 11,id = 38104,num = 1};
get_type_task_dynamic(400300,Lv) when Lv >= 106 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=400300,slv=106, elv=159,start_npc = 100311,end_npc = 0,scene = 10004,x = 4888,y = 3511,content_type = 1,id = 10001023,num = 15};
get_type_task_dynamic(400301,Lv) when Lv >= 106 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=400301,slv=106, elv=159,start_npc = 100315,end_npc = 0,scene = 10004,x = 6576,y = 4541,content_type = 1,id = 10001024,num = 15};
get_type_task_dynamic(400302,Lv) when Lv >= 106 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=400302,slv=106, elv=159,start_npc = 100317,end_npc = 0,scene = 10004,x = 5341,y = 5388,content_type = 1,id = 10001025,num = 15};
get_type_task_dynamic(400303,Lv) when Lv >= 106 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=400303,slv=106, elv=159,start_npc = 100321,end_npc = 0,scene = 10004,x = 913,y = 4239,content_type = 1,id = 10001026,num = 15};
get_type_task_dynamic(400304,Lv) when Lv >= 106 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=400304,slv=106, elv=159,start_npc = 100311,end_npc = 0,scene = 10004,x = 3571,y = 525,content_type = 11,id = 38401,num = 1};
get_type_task_dynamic(400305,Lv) when Lv >= 106 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=400305,slv=106, elv=159,start_npc = 100315,end_npc = 0,scene = 10004,x = 6226,y = 2137,content_type = 11,id = 38402,num = 1};
get_type_task_dynamic(400306,Lv) when Lv >= 106 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=400306,slv=106, elv=159,start_npc = 100317,end_npc = 0,scene = 10004,x = 4808,y = 3405,content_type = 11,id = 38403,num = 1};
get_type_task_dynamic(400307,Lv) when Lv >= 106 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=400307,slv=106, elv=159,start_npc = 100321,end_npc = 0,scene = 10004,x = 6533,y = 4530,content_type = 11,id = 38404,num = 1};
get_type_task_dynamic(400400,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=400400,slv=160, elv=180,start_npc = 100402,end_npc = 0,scene = 10005,x = 1336,y = 4643,content_type = 1,id = 10001028,num = 20};
get_type_task_dynamic(400401,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=400401,slv=160, elv=180,start_npc = 100404,end_npc = 0,scene = 10005,x = 1632,y = 1765,content_type = 1,id = 10001029,num = 20};
get_type_task_dynamic(400402,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=400402,slv=160, elv=180,start_npc = 100406,end_npc = 0,scene = 10005,x = 5056,y = 1365,content_type = 1,id = 10001030,num = 20};
get_type_task_dynamic(400403,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=400403,slv=160, elv=180,start_npc = 100408,end_npc = 0,scene = 10005,x = 7160,y = 2574,content_type = 1,id = 10001031,num = 20};
get_type_task_dynamic(400404,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=400404,slv=160, elv=180,start_npc = 100402,end_npc = 0,scene = 10005,x = 4998,y = 1312,content_type = 11,id = 38501,num = 1};
get_type_task_dynamic(400405,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=400405,slv=160, elv=180,start_npc = 100404,end_npc = 0,scene = 10005,x = 7180,y = 2482,content_type = 11,id = 38502,num = 1};
get_type_task_dynamic(400406,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=400406,slv=160, elv=180,start_npc = 100406,end_npc = 0,scene = 10005,x = 5193,y = 4575,content_type = 11,id = 38503,num = 1};
get_type_task_dynamic(400407,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=400407,slv=160, elv=180,start_npc = 100408,end_npc = 0,scene = 10005,x = 3070,y = 3330,content_type = 11,id = 38504,num = 1};
get_type_task_dynamic(400500,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=400500,slv=181, elv=239,start_npc = 100413,end_npc = 0,scene = 10005,x = 8631,y = 4300,content_type = 1,id = 10001032,num = 20};
get_type_task_dynamic(400501,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=400501,slv=181, elv=239,start_npc = 100416,end_npc = 0,scene = 10005,x = 4767,y = 6874,content_type = 1,id = 10001033,num = 20};
get_type_task_dynamic(400502,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=400502,slv=181, elv=239,start_npc = 100418,end_npc = 0,scene = 10005,x = 3001,y = 5963,content_type = 1,id = 10001034,num = 20};
get_type_task_dynamic(400503,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=400503,slv=181, elv=239,start_npc = 100425,end_npc = 0,scene = 10005,x = 3226,y = 3438,content_type = 1,id = 10001035,num = 20};
get_type_task_dynamic(400504,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=400504,slv=181, elv=239,start_npc = 100413,end_npc = 0,scene = 10005,x = 4998,y = 1312,content_type = 11,id = 38501,num = 1};
get_type_task_dynamic(400505,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=400505,slv=181, elv=239,start_npc = 100416,end_npc = 0,scene = 10005,x = 7180,y = 2482,content_type = 11,id = 38502,num = 1};
get_type_task_dynamic(400506,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=400506,slv=181, elv=239,start_npc = 100418,end_npc = 0,scene = 10005,x = 5193,y = 4575,content_type = 11,id = 38503,num = 1};
get_type_task_dynamic(400507,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=400507,slv=181, elv=239,start_npc = 100425,end_npc = 0,scene = 10005,x = 3070,y = 3330,content_type = 11,id = 38504,num = 1};
get_type_task_dynamic(400600,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400600,slv=240, elv=299,start_npc = 100501,end_npc = 0,scene = 10006,x = 5522,y = 3565,content_type = 1,id = 10001037,num = 20};
get_type_task_dynamic(400601,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400601,slv=240, elv=299,start_npc = 100504,end_npc = 0,scene = 10006,x = 5891,y = 1336,content_type = 1,id = 10001038,num = 20};
get_type_task_dynamic(400602,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400602,slv=240, elv=299,start_npc = 100506,end_npc = 0,scene = 10006,x = 4579,y = 1007,content_type = 1,id = 10001039,num = 20};
get_type_task_dynamic(400603,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400603,slv=240, elv=299,start_npc = 100507,end_npc = 0,scene = 10006,x = 2491,y = 1016,content_type = 1,id = 10001040,num = 20};
get_type_task_dynamic(400604,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400604,slv=240, elv=299,start_npc = 100501,end_npc = 0,scene = 10006,x = 5499,y = 3344,content_type = 11,id = 38601,num = 1};
get_type_task_dynamic(400605,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400605,slv=240, elv=299,start_npc = 100504,end_npc = 0,scene = 10006,x = 5744,y = 1027,content_type = 11,id = 38602,num = 1};
get_type_task_dynamic(400606,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400606,slv=240, elv=299,start_npc = 100506,end_npc = 0,scene = 10006,x = 1390,y = 1615,content_type = 11,id = 38603,num = 1};
get_type_task_dynamic(400607,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400607,slv=240, elv=299,start_npc = 100507,end_npc = 0,scene = 10006,x = 3185,y = 3656,content_type = 11,id = 38604,num = 1};
get_type_task_dynamic(400700,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400700,slv=240, elv=299,start_npc = 100511,end_npc = 0,scene = 10006,x = 1307,y = 2443,content_type = 1,id = 10001041,num = 20};
get_type_task_dynamic(400701,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400701,slv=240, elv=299,start_npc = 100512,end_npc = 0,scene = 10006,x = 2828,y = 2350,content_type = 1,id = 10001042,num = 20};
get_type_task_dynamic(400702,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400702,slv=240, elv=299,start_npc = 100514,end_npc = 0,scene = 10006,x = 3116,y = 3700,content_type = 1,id = 10001043,num = 20};
get_type_task_dynamic(400703,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=400703,slv=300, elv=379,start_npc = 100518,end_npc = 0,scene = 10002,x = 6262,y = 4110,content_type = 1,id = 10001044,num = 20};
get_type_task_dynamic(400704,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400704,slv=240, elv=299,start_npc = 100511,end_npc = 0,scene = 10006,x = 5499,y = 3344,content_type = 11,id = 38601,num = 1};
get_type_task_dynamic(400705,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400705,slv=240, elv=299,start_npc = 100512,end_npc = 0,scene = 10006,x = 5744,y = 1027,content_type = 11,id = 38602,num = 1};
get_type_task_dynamic(400706,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=400706,slv=240, elv=299,start_npc = 100514,end_npc = 0,scene = 10006,x = 1390,y = 1615,content_type = 11,id = 38603,num = 1};
get_type_task_dynamic(400707,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=400707,slv=300, elv=379,start_npc = 100518,end_npc = 0,scene = 10002,x = 2400,y = 2300,content_type = 11,id = 38204,num = 1};
get_type_task_dynamic(400800,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=400800,slv=300, elv=379,start_npc = 100522,end_npc = 0,scene = 10002,x = 4996,y = 580,content_type = 1,id = 10001047,num = 20};
get_type_task_dynamic(400801,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=400801,slv=300, elv=379,start_npc = 100526,end_npc = 0,scene = 10002,x = 638,y = 713,content_type = 1,id = 10001049,num = 20};
get_type_task_dynamic(400802,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=400802,slv=300, elv=379,start_npc = 100604,end_npc = 0,scene = 10002,x = 1366,y = 4162,content_type = 1,id = 10001051,num = 20};
get_type_task_dynamic(400803,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=400803,slv=380, elv=489,start_npc = 100705,end_npc = 0,scene = 10007,x = 1072,y = 3251,content_type = 1,id = 10001054,num = 20};
get_type_task_dynamic(400804,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=400804,slv=300, elv=379,start_npc = 100522,end_npc = 0,scene = 10002,x = 6271,y = 2981,content_type = 11,id = 38201,num = 1};
get_type_task_dynamic(400805,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=400805,slv=300, elv=379,start_npc = 100526,end_npc = 0,scene = 10002,x = 4469,y = 5497,content_type = 11,id = 38202,num = 1};
get_type_task_dynamic(400806,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=400806,slv=300, elv=379,start_npc = 100604,end_npc = 0,scene = 10002,x = 1486,y = 3907,content_type = 11,id = 38203,num = 1};
get_type_task_dynamic(400807,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=400807,slv=380, elv=489,start_npc = 100705,end_npc = 0,scene = 10007,x = 8104,y = 4951,content_type = 11,id = 38704,num = 1};
get_type_task_dynamic(400900,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=400900,slv=380, elv=489,start_npc = 100806,end_npc = 0,scene = 10007,x = 4475,y = 822,content_type = 1,id = 10001057,num = 20};
get_type_task_dynamic(400901,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=400901,slv=380, elv=489,start_npc = 100809,end_npc = 0,scene = 10007,x = 5835,y = 1066,content_type = 1,id = 10001058,num = 20};
get_type_task_dynamic(400902,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=400902,slv=380, elv=489,start_npc = 100812,end_npc = 0,scene = 10007,x = 4964,y = 5059,content_type = 1,id = 10001059,num = 20};
get_type_task_dynamic(400903,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=400903,slv=380, elv=489,start_npc = 100817,end_npc = 0,scene = 10007,x = 8365,y = 2501,content_type = 1,id = 10001061,num = 20};
get_type_task_dynamic(400904,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=400904,slv=380, elv=489,start_npc = 100806,end_npc = 0,scene = 10007,x = 1864,y = 4669,content_type = 11,id = 38701,num = 1};
get_type_task_dynamic(400905,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=400905,slv=380, elv=489,start_npc = 100809,end_npc = 0,scene = 10007,x = 3340,y = 2095,content_type = 11,id = 38702,num = 1};
get_type_task_dynamic(400906,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=400906,slv=380, elv=489,start_npc = 100812,end_npc = 0,scene = 10007,x = 4996,y = 5053,content_type = 11,id = 38703,num = 1};
get_type_task_dynamic(400907,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=400907,slv=380, elv=489,start_npc = 100817,end_npc = 0,scene = 10007,x = 8104,y = 4951,content_type = 11,id = 38704,num = 1};
get_type_task_dynamic(401000,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401000,slv=490, elv=569,start_npc = 100901,end_npc = 0,scene = 10003,x = 4251,y = 1300,content_type = 1,id = 10001062,num = 20};
get_type_task_dynamic(401001,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401001,slv=490, elv=569,start_npc = 100905,end_npc = 0,scene = 10003,x = 6369,y = 2993,content_type = 1,id = 10001063,num = 20};
get_type_task_dynamic(401002,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401002,slv=490, elv=569,start_npc = 100907,end_npc = 0,scene = 10003,x = 6657,y = 5347,content_type = 1,id = 10001064,num = 20};
get_type_task_dynamic(401003,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401003,slv=490, elv=569,start_npc = 100914,end_npc = 0,scene = 10003,x = 980,y = 4546,content_type = 1,id = 10001066,num = 20};
get_type_task_dynamic(401004,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401004,slv=490, elv=569,start_npc = 100901,end_npc = 0,scene = 10003,x = 5072,y = 7051,content_type = 11,id = 38302,num = 1};
get_type_task_dynamic(401005,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401005,slv=490, elv=569,start_npc = 100905,end_npc = 0,scene = 10003,x = 4540,y = 4411,content_type = 11,id = 38301,num = 1};
get_type_task_dynamic(401006,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401006,slv=490, elv=569,start_npc = 100907,end_npc = 0,scene = 10003,x = 2425,y = 2956,content_type = 11,id = 38304,num = 1};
get_type_task_dynamic(401007,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401007,slv=490, elv=569,start_npc = 100914,end_npc = 0,scene = 10003,x = 1495,y = 5634,content_type = 11,id = 38303,num = 1};
get_type_task_dynamic(401100,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401100,slv=490, elv=569,start_npc = 100916,end_npc = 0,scene = 10003,x = 2159,y = 2738,content_type = 1,id = 10001067,num = 20};
get_type_task_dynamic(401101,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401101,slv=570, elv=9999,start_npc = 100933,end_npc = 0,scene = 10008,x = 5585,y = 2823,content_type = 1,id = 10001068,num = 20};
get_type_task_dynamic(401102,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=401102,slv=380, elv=489,start_npc = 100815,end_npc = 0,scene = 10007,x = 8161,y = 5065,content_type = 1,id = 10001060,num = 20};
get_type_task_dynamic(401103,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401103,slv=490, elv=569,start_npc = 100911,end_npc = 0,scene = 10003,x = 1043,y = 6292,content_type = 1,id = 10001065,num = 20};
get_type_task_dynamic(401104,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401104,slv=490, elv=569,start_npc = 100916,end_npc = 0,scene = 10003,x = 5072,y = 7051,content_type = 11,id = 38302,num = 1};
get_type_task_dynamic(401105,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401105,slv=570, elv=9999,start_npc = 100933,end_npc = 0,scene = 10008,x = 1787,y = 6047,content_type = 11,id = 38804,num = 1};
get_type_task_dynamic(401106,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=401106,slv=380, elv=489,start_npc = 100815,end_npc = 0,scene = 10007,x = 1864,y = 4669,content_type = 11,id = 38701,num = 1};
get_type_task_dynamic(401107,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=401107,slv=490, elv=569,start_npc = 100911,end_npc = 0,scene = 10003,x = 1495,y = 5634,content_type = 11,id = 38303,num = 1};
get_type_task_dynamic(401200,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401200,slv=570, elv=9999,start_npc = 100922,end_npc = 0,scene = 10008,x = 7430,y = 1895,content_type = 1,id = 10001069,num = 20};
get_type_task_dynamic(401201,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401201,slv=570, elv=9999,start_npc = 100925,end_npc = 0,scene = 10008,x = 8739,y = 1349,content_type = 1,id = 10001081,num = 20};
get_type_task_dynamic(401202,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401202,slv=570, elv=9999,start_npc = 100928,end_npc = 0,scene = 10008,x = 9785,y = 3624,content_type = 1,id = 10001072,num = 20};
get_type_task_dynamic(401203,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401203,slv=570, elv=9999,start_npc = 100932,end_npc = 0,scene = 10008,x = 7255,y = 4576,content_type = 1,id = 10001074,num = 20};
get_type_task_dynamic(401204,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401204,slv=570, elv=9999,start_npc = 100922,end_npc = 0,scene = 10008,x = 5611,y = 2831,content_type = 11,id = 38801,num = 1};
get_type_task_dynamic(401205,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401205,slv=570, elv=9999,start_npc = 100925,end_npc = 0,scene = 10008,x = 1787,y = 6047,content_type = 11,id = 38804,num = 1};
get_type_task_dynamic(401206,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401206,slv=570, elv=9999,start_npc = 100928,end_npc = 0,scene = 10008,x = 7583,y = 685,content_type = 11,id = 38802,num = 1};
get_type_task_dynamic(401207,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401207,slv=570, elv=9999,start_npc = 100932,end_npc = 0,scene = 10008,x = 7002,y = 7160,content_type = 11,id = 38803,num = 1};
get_type_task_dynamic(401300,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401300,slv=570, elv=9999,start_npc = 100936,end_npc = 0,scene = 10008,x = 6900,y = 7201,content_type = 1,id = 10001075,num = 20};
get_type_task_dynamic(401301,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401301,slv=570, elv=9999,start_npc = 100939,end_npc = 0,scene = 10008,x = 4827,y = 7905,content_type = 1,id = 10001076,num = 20};
get_type_task_dynamic(401302,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401302,slv=570, elv=9999,start_npc = 100947,end_npc = 0,scene = 10008,x = 2689,y = 4185,content_type = 1,id = 10001079,num = 20};
get_type_task_dynamic(401303,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401303,slv=570, elv=9999,start_npc = 100949,end_npc = 0,scene = 10008,x = 1277,y = 3579,content_type = 1,id = 10001080,num = 20};
get_type_task_dynamic(401304,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401304,slv=570, elv=9999,start_npc = 100936,end_npc = 0,scene = 10008,x = 5611,y = 2831,content_type = 11,id = 38801,num = 1};
get_type_task_dynamic(401305,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401305,slv=570, elv=9999,start_npc = 100939,end_npc = 0,scene = 10008,x = 1787,y = 6047,content_type = 11,id = 38804,num = 1};
get_type_task_dynamic(401306,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401306,slv=570, elv=9999,start_npc = 100947,end_npc = 0,scene = 10008,x = 7583,y = 685,content_type = 11,id = 38802,num = 1};
get_type_task_dynamic(401307,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=401307,slv=570, elv=9999,start_npc = 100949,end_npc = 0,scene = 10008,x = 7002,y = 7160,content_type = 11,id = 38803,num = 1};
get_type_task_dynamic(500100,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=500100,slv=65, elv=99,start_npc = 100212,end_npc = 0,scene = 10001,x = 488,y = 3770,content_type = 1,id = 10001016,num = 15};
get_type_task_dynamic(500101,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=500101,slv=65, elv=99,start_npc = 100204,end_npc = 0,scene = 10001,x = 5261,y = 1215,content_type = 1,id = 10001014,num = 15};
get_type_task_dynamic(500102,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=500102,slv=65, elv=99,start_npc = 100210,end_npc = 0,scene = 10001,x = 2803,y = 1563,content_type = 1,id = 10001015,num = 15};
get_type_task_dynamic(500103,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=500103,slv=65, elv=99,start_npc = 100212,end_npc = 0,scene = 10001,x = 488,y = 3770,content_type = 1,id = 10001016,num = 15};
get_type_task_dynamic(500104,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=500104,slv=65, elv=99,start_npc = 100212,end_npc = 0,scene = 10001,x = 5247,y = 2715,content_type = 11,id = 38101,num = 1};
get_type_task_dynamic(500105,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=500105,slv=65, elv=99,start_npc = 100204,end_npc = 0,scene = 10001,x = 5114,y = 1056,content_type = 11,id = 38102,num = 1};
get_type_task_dynamic(500106,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=500106,slv=65, elv=99,start_npc = 100210,end_npc = 0,scene = 10001,x = 1222,y = 3492,content_type = 11,id = 38103,num = 1};
get_type_task_dynamic(500107,Lv) when Lv >= 65 andalso Lv =< 99->
    #task_lv_dynamic_content{task_id=500107,slv=65, elv=99,start_npc = 100212,end_npc = 0,scene = 10001,x = 1243,y = 1749,content_type = 11,id = 38104,num = 1};
get_type_task_dynamic(500200,Lv) when Lv >= 100 andalso Lv =< 109->
    #task_lv_dynamic_content{task_id=500200,slv=100, elv=109,start_npc = 100213,end_npc = 0,scene = 10001,x = 488,y = 3770,content_type = 1,id = 10001016,num = 15};
get_type_task_dynamic(500201,Lv) when Lv >= 100 andalso Lv =< 109->
    #task_lv_dynamic_content{task_id=500201,slv=100, elv=109,start_npc = 100215,end_npc = 0,scene = 10001,x = 1222,y = 3154,content_type = 1,id = 10001017,num = 15};
get_type_task_dynamic(500202,Lv) when Lv >= 100 andalso Lv =< 109->
    #task_lv_dynamic_content{task_id=500202,slv=100, elv=109,start_npc = 100218,end_npc = 0,scene = 10001,x = 1357,y = 1812,content_type = 1,id = 10001018,num = 15};
get_type_task_dynamic(500203,Lv) when Lv >= 100 andalso Lv =< 109->
    #task_lv_dynamic_content{task_id=500203,slv=100, elv=109,start_npc = 100220,end_npc = 0,scene = 10001,x = 984,y = 686,content_type = 1,id = 10001019,num = 15};
get_type_task_dynamic(500204,Lv) when Lv >= 100 andalso Lv =< 109->
    #task_lv_dynamic_content{task_id=500204,slv=100, elv=109,start_npc = 100213,end_npc = 0,scene = 10001,x = 5247,y = 2715,content_type = 11,id = 38101,num = 1};
get_type_task_dynamic(500205,Lv) when Lv >= 100 andalso Lv =< 109->
    #task_lv_dynamic_content{task_id=500205,slv=100, elv=109,start_npc = 100215,end_npc = 0,scene = 10001,x = 5114,y = 1056,content_type = 11,id = 38102,num = 1};
get_type_task_dynamic(500206,Lv) when Lv >= 100 andalso Lv =< 109->
    #task_lv_dynamic_content{task_id=500206,slv=100, elv=109,start_npc = 100218,end_npc = 0,scene = 10001,x = 1222,y = 3492,content_type = 11,id = 38103,num = 1};
get_type_task_dynamic(500207,Lv) when Lv >= 100 andalso Lv =< 109->
    #task_lv_dynamic_content{task_id=500207,slv=100, elv=109,start_npc = 100220,end_npc = 0,scene = 10001,x = 1243,y = 1749,content_type = 11,id = 38104,num = 1};
get_type_task_dynamic(500300,Lv) when Lv >= 110 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=500300,slv=110, elv=159,start_npc = 100311,end_npc = 0,scene = 10004,x = 4888,y = 3511,content_type = 1,id = 10001023,num = 15};
get_type_task_dynamic(500301,Lv) when Lv >= 110 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=500301,slv=110, elv=159,start_npc = 100315,end_npc = 0,scene = 10004,x = 6576,y = 4541,content_type = 1,id = 10001024,num = 15};
get_type_task_dynamic(500302,Lv) when Lv >= 110 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=500302,slv=110, elv=159,start_npc = 100317,end_npc = 0,scene = 10004,x = 5341,y = 5388,content_type = 1,id = 10001025,num = 15};
get_type_task_dynamic(500303,Lv) when Lv >= 110 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=500303,slv=110, elv=159,start_npc = 100321,end_npc = 0,scene = 10004,x = 913,y = 4239,content_type = 1,id = 10001026,num = 15};
get_type_task_dynamic(500304,Lv) when Lv >= 110 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=500304,slv=110, elv=159,start_npc = 100311,end_npc = 0,scene = 10004,x = 3571,y = 525,content_type = 11,id = 38401,num = 1};
get_type_task_dynamic(500305,Lv) when Lv >= 110 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=500305,slv=110, elv=159,start_npc = 100315,end_npc = 0,scene = 10004,x = 6226,y = 2137,content_type = 11,id = 38402,num = 1};
get_type_task_dynamic(500306,Lv) when Lv >= 110 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=500306,slv=110, elv=159,start_npc = 100317,end_npc = 0,scene = 10004,x = 4808,y = 3405,content_type = 11,id = 38403,num = 1};
get_type_task_dynamic(500307,Lv) when Lv >= 110 andalso Lv =< 159->
    #task_lv_dynamic_content{task_id=500307,slv=110, elv=159,start_npc = 100321,end_npc = 0,scene = 10004,x = 6533,y = 4530,content_type = 11,id = 38404,num = 1};
get_type_task_dynamic(500400,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=500400,slv=160, elv=180,start_npc = 100402,end_npc = 0,scene = 10005,x = 1336,y = 4643,content_type = 1,id = 10001028,num = 20};
get_type_task_dynamic(500401,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=500401,slv=160, elv=180,start_npc = 100404,end_npc = 0,scene = 10005,x = 1632,y = 1765,content_type = 1,id = 10001029,num = 20};
get_type_task_dynamic(500402,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=500402,slv=160, elv=180,start_npc = 100406,end_npc = 0,scene = 10005,x = 5056,y = 1365,content_type = 1,id = 10001030,num = 20};
get_type_task_dynamic(500403,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=500403,slv=160, elv=180,start_npc = 100408,end_npc = 0,scene = 10005,x = 7160,y = 2574,content_type = 1,id = 10001031,num = 20};
get_type_task_dynamic(500404,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=500404,slv=160, elv=180,start_npc = 100402,end_npc = 0,scene = 10005,x = 4998,y = 1312,content_type = 11,id = 38501,num = 1};
get_type_task_dynamic(500405,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=500405,slv=160, elv=180,start_npc = 100404,end_npc = 0,scene = 10005,x = 7180,y = 2482,content_type = 11,id = 38502,num = 1};
get_type_task_dynamic(500406,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=500406,slv=160, elv=180,start_npc = 100406,end_npc = 0,scene = 10005,x = 5193,y = 4575,content_type = 11,id = 38503,num = 1};
get_type_task_dynamic(500407,Lv) when Lv >= 160 andalso Lv =< 180->
    #task_lv_dynamic_content{task_id=500407,slv=160, elv=180,start_npc = 100408,end_npc = 0,scene = 10005,x = 3070,y = 3330,content_type = 11,id = 38504,num = 1};
get_type_task_dynamic(500500,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=500500,slv=181, elv=239,start_npc = 100413,end_npc = 0,scene = 10005,x = 8631,y = 4300,content_type = 1,id = 10001032,num = 20};
get_type_task_dynamic(500501,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=500501,slv=181, elv=239,start_npc = 100416,end_npc = 0,scene = 10005,x = 4767,y = 6874,content_type = 1,id = 10001033,num = 20};
get_type_task_dynamic(500502,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=500502,slv=181, elv=239,start_npc = 100418,end_npc = 0,scene = 10005,x = 3001,y = 5963,content_type = 1,id = 10001034,num = 20};
get_type_task_dynamic(500503,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=500503,slv=181, elv=239,start_npc = 100425,end_npc = 0,scene = 10005,x = 3226,y = 3438,content_type = 1,id = 10001035,num = 20};
get_type_task_dynamic(500504,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=500504,slv=181, elv=239,start_npc = 100413,end_npc = 0,scene = 10005,x = 4998,y = 1312,content_type = 11,id = 38501,num = 1};
get_type_task_dynamic(500505,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=500505,slv=181, elv=239,start_npc = 100416,end_npc = 0,scene = 10005,x = 7180,y = 2482,content_type = 11,id = 38502,num = 1};
get_type_task_dynamic(500506,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=500506,slv=181, elv=239,start_npc = 100418,end_npc = 0,scene = 10005,x = 5193,y = 4575,content_type = 11,id = 38503,num = 1};
get_type_task_dynamic(500507,Lv) when Lv >= 181 andalso Lv =< 239->
    #task_lv_dynamic_content{task_id=500507,slv=181, elv=239,start_npc = 100425,end_npc = 0,scene = 10005,x = 3070,y = 3330,content_type = 11,id = 38504,num = 1};
get_type_task_dynamic(500600,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500600,slv=240, elv=299,start_npc = 100501,end_npc = 0,scene = 10006,x = 5522,y = 3565,content_type = 1,id = 10001037,num = 20};
get_type_task_dynamic(500601,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500601,slv=240, elv=299,start_npc = 100504,end_npc = 0,scene = 10006,x = 5891,y = 1336,content_type = 1,id = 10001038,num = 20};
get_type_task_dynamic(500602,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500602,slv=240, elv=299,start_npc = 100506,end_npc = 0,scene = 10006,x = 4579,y = 1007,content_type = 1,id = 10001039,num = 20};
get_type_task_dynamic(500603,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500603,slv=240, elv=299,start_npc = 100507,end_npc = 0,scene = 10006,x = 2491,y = 1016,content_type = 1,id = 10001040,num = 20};
get_type_task_dynamic(500604,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500604,slv=240, elv=299,start_npc = 100501,end_npc = 0,scene = 10006,x = 5499,y = 3344,content_type = 11,id = 38601,num = 1};
get_type_task_dynamic(500605,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500605,slv=240, elv=299,start_npc = 100504,end_npc = 0,scene = 10006,x = 5744,y = 1027,content_type = 11,id = 38602,num = 1};
get_type_task_dynamic(500606,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500606,slv=240, elv=299,start_npc = 100506,end_npc = 0,scene = 10006,x = 1390,y = 1615,content_type = 11,id = 38603,num = 1};
get_type_task_dynamic(500607,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500607,slv=240, elv=299,start_npc = 100507,end_npc = 0,scene = 10006,x = 3185,y = 3656,content_type = 11,id = 38604,num = 1};
get_type_task_dynamic(500700,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500700,slv=240, elv=299,start_npc = 100511,end_npc = 0,scene = 10006,x = 1307,y = 2443,content_type = 1,id = 10001041,num = 20};
get_type_task_dynamic(500701,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500701,slv=240, elv=299,start_npc = 100512,end_npc = 0,scene = 10006,x = 2828,y = 2350,content_type = 1,id = 10001042,num = 20};
get_type_task_dynamic(500702,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500702,slv=240, elv=299,start_npc = 100514,end_npc = 0,scene = 10006,x = 3116,y = 3700,content_type = 1,id = 10001043,num = 20};
get_type_task_dynamic(500703,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=500703,slv=300, elv=379,start_npc = 100518,end_npc = 0,scene = 10002,x = 6262,y = 4110,content_type = 1,id = 10001044,num = 20};
get_type_task_dynamic(500704,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500704,slv=240, elv=299,start_npc = 100511,end_npc = 0,scene = 10006,x = 5499,y = 3344,content_type = 11,id = 38601,num = 1};
get_type_task_dynamic(500705,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500705,slv=240, elv=299,start_npc = 100512,end_npc = 0,scene = 10006,x = 5744,y = 1027,content_type = 11,id = 38602,num = 1};
get_type_task_dynamic(500706,Lv) when Lv >= 240 andalso Lv =< 299->
    #task_lv_dynamic_content{task_id=500706,slv=240, elv=299,start_npc = 100514,end_npc = 0,scene = 10006,x = 1390,y = 1615,content_type = 11,id = 38603,num = 1};
get_type_task_dynamic(500707,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=500707,slv=300, elv=379,start_npc = 100518,end_npc = 0,scene = 10002,x = 2400,y = 2300,content_type = 11,id = 38204,num = 1};
get_type_task_dynamic(500800,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=500800,slv=300, elv=379,start_npc = 100522,end_npc = 0,scene = 10002,x = 4996,y = 580,content_type = 1,id = 10001047,num = 20};
get_type_task_dynamic(500801,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=500801,slv=300, elv=379,start_npc = 100526,end_npc = 0,scene = 10002,x = 638,y = 713,content_type = 1,id = 10001049,num = 20};
get_type_task_dynamic(500802,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=500802,slv=300, elv=379,start_npc = 100604,end_npc = 0,scene = 10002,x = 1366,y = 4162,content_type = 1,id = 10001051,num = 20};
get_type_task_dynamic(500803,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=500803,slv=380, elv=489,start_npc = 100705,end_npc = 0,scene = 10007,x = 1072,y = 3251,content_type = 1,id = 10001054,num = 20};
get_type_task_dynamic(500804,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=500804,slv=300, elv=379,start_npc = 100522,end_npc = 0,scene = 10002,x = 6271,y = 2981,content_type = 11,id = 38201,num = 1};
get_type_task_dynamic(500805,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=500805,slv=300, elv=379,start_npc = 100526,end_npc = 0,scene = 10002,x = 4469,y = 5497,content_type = 11,id = 38202,num = 1};
get_type_task_dynamic(500806,Lv) when Lv >= 300 andalso Lv =< 379->
    #task_lv_dynamic_content{task_id=500806,slv=300, elv=379,start_npc = 100604,end_npc = 0,scene = 10002,x = 1486,y = 3907,content_type = 11,id = 38203,num = 1};
get_type_task_dynamic(500806,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=500806,slv=380, elv=489,start_npc = 100705,end_npc = 0,scene = 10007,x = 8104,y = 4951,content_type = 11,id = 38704,num = 1};
get_type_task_dynamic(500807,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=500807,slv=380, elv=489,start_npc = 100806,end_npc = 0,scene = 10007,x = 4475,y = 822,content_type = 1,id = 10001057,num = 20};
get_type_task_dynamic(500900,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=500900,slv=380, elv=489,start_npc = 100809,end_npc = 0,scene = 10007,x = 5835,y = 1066,content_type = 1,id = 10001058,num = 20};
get_type_task_dynamic(500901,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=500901,slv=380, elv=489,start_npc = 100812,end_npc = 0,scene = 10007,x = 4964,y = 5059,content_type = 1,id = 10001059,num = 20};
get_type_task_dynamic(500902,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=500902,slv=380, elv=489,start_npc = 100817,end_npc = 0,scene = 10007,x = 8365,y = 2501,content_type = 1,id = 10001061,num = 20};
get_type_task_dynamic(500903,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=500903,slv=380, elv=489,start_npc = 100806,end_npc = 0,scene = 10007,x = 1864,y = 4669,content_type = 11,id = 38701,num = 1};
get_type_task_dynamic(500904,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=500904,slv=380, elv=489,start_npc = 100809,end_npc = 0,scene = 10007,x = 3340,y = 2095,content_type = 11,id = 38702,num = 1};
get_type_task_dynamic(500905,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=500905,slv=380, elv=489,start_npc = 100812,end_npc = 0,scene = 10007,x = 4996,y = 5053,content_type = 11,id = 38703,num = 1};
get_type_task_dynamic(500906,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=500906,slv=380, elv=489,start_npc = 100817,end_npc = 0,scene = 10007,x = 8104,y = 4951,content_type = 11,id = 38704,num = 1};
get_type_task_dynamic(500907,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=500907,slv=490, elv=569,start_npc = 100901,end_npc = 0,scene = 10003,x = 4251,y = 1300,content_type = 1,id = 10001062,num = 20};
get_type_task_dynamic(501000,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501000,slv=490, elv=569,start_npc = 100905,end_npc = 0,scene = 10003,x = 6369,y = 2993,content_type = 1,id = 10001063,num = 20};
get_type_task_dynamic(501001,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501001,slv=490, elv=569,start_npc = 100907,end_npc = 0,scene = 10003,x = 6657,y = 5347,content_type = 1,id = 10001064,num = 20};
get_type_task_dynamic(501002,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501002,slv=490, elv=569,start_npc = 100914,end_npc = 0,scene = 10003,x = 980,y = 4546,content_type = 1,id = 10001066,num = 20};
get_type_task_dynamic(501003,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501003,slv=490, elv=569,start_npc = 100901,end_npc = 0,scene = 10003,x = 5072,y = 7051,content_type = 11,id = 38302,num = 1};
get_type_task_dynamic(501004,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501004,slv=490, elv=569,start_npc = 100905,end_npc = 0,scene = 10003,x = 4540,y = 4411,content_type = 11,id = 38301,num = 1};
get_type_task_dynamic(501005,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501005,slv=490, elv=569,start_npc = 100907,end_npc = 0,scene = 10003,x = 2425,y = 2956,content_type = 11,id = 38304,num = 1};
get_type_task_dynamic(501006,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501006,slv=490, elv=569,start_npc = 100914,end_npc = 0,scene = 10003,x = 1495,y = 5634,content_type = 11,id = 38303,num = 1};
get_type_task_dynamic(501007,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501007,slv=490, elv=569,start_npc = 100916,end_npc = 0,scene = 10003,x = 2159,y = 2738,content_type = 1,id = 10001067,num = 20};
get_type_task_dynamic(501100,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501100,slv=570, elv=9999,start_npc = 100933,end_npc = 0,scene = 10008,x = 5585,y = 2823,content_type = 1,id = 10001068,num = 20};
get_type_task_dynamic(501101,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=501101,slv=380, elv=489,start_npc = 100815,end_npc = 0,scene = 10007,x = 8161,y = 5065,content_type = 1,id = 10001060,num = 20};
get_type_task_dynamic(501102,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501102,slv=490, elv=569,start_npc = 100911,end_npc = 0,scene = 10003,x = 1043,y = 6292,content_type = 1,id = 10001065,num = 20};
get_type_task_dynamic(501103,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501103,slv=490, elv=569,start_npc = 100916,end_npc = 0,scene = 10003,x = 5072,y = 7051,content_type = 11,id = 38302,num = 1};
get_type_task_dynamic(501104,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501104,slv=570, elv=9999,start_npc = 100933,end_npc = 0,scene = 10008,x = 1787,y = 6047,content_type = 11,id = 38804,num = 1};
get_type_task_dynamic(501105,Lv) when Lv >= 380 andalso Lv =< 489->
    #task_lv_dynamic_content{task_id=501105,slv=380, elv=489,start_npc = 100815,end_npc = 0,scene = 10007,x = 1864,y = 4669,content_type = 11,id = 38701,num = 1};
get_type_task_dynamic(501106,Lv) when Lv >= 490 andalso Lv =< 569->
    #task_lv_dynamic_content{task_id=501106,slv=490, elv=569,start_npc = 100911,end_npc = 0,scene = 10003,x = 1495,y = 5634,content_type = 11,id = 38303,num = 1};
get_type_task_dynamic(501107,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501107,slv=570, elv=9999,start_npc = 100922,end_npc = 0,scene = 10008,x = 7430,y = 1895,content_type = 1,id = 10001069,num = 20};
get_type_task_dynamic(501200,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501200,slv=570, elv=9999,start_npc = 100925,end_npc = 0,scene = 10008,x = 8739,y = 1349,content_type = 1,id = 10001081,num = 20};
get_type_task_dynamic(501201,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501201,slv=570, elv=9999,start_npc = 100928,end_npc = 0,scene = 10008,x = 9785,y = 3624,content_type = 1,id = 10001072,num = 20};
get_type_task_dynamic(501202,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501202,slv=570, elv=9999,start_npc = 100932,end_npc = 0,scene = 10008,x = 7255,y = 4576,content_type = 1,id = 10001074,num = 20};
get_type_task_dynamic(501203,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501203,slv=570, elv=9999,start_npc = 100922,end_npc = 0,scene = 10008,x = 5611,y = 2831,content_type = 11,id = 38801,num = 1};
get_type_task_dynamic(501204,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501204,slv=570, elv=9999,start_npc = 100925,end_npc = 0,scene = 10008,x = 1787,y = 6047,content_type = 11,id = 38804,num = 1};
get_type_task_dynamic(501205,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501205,slv=570, elv=9999,start_npc = 100928,end_npc = 0,scene = 10008,x = 7583,y = 685,content_type = 11,id = 38802,num = 1};
get_type_task_dynamic(501206,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501206,slv=570, elv=9999,start_npc = 100932,end_npc = 0,scene = 10008,x = 7002,y = 7160,content_type = 11,id = 38803,num = 1};
get_type_task_dynamic(501207,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501207,slv=570, elv=9999,start_npc = 100936,end_npc = 0,scene = 10008,x = 6900,y = 7201,content_type = 1,id = 10001075,num = 20};
get_type_task_dynamic(501300,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501300,slv=570, elv=9999,start_npc = 100939,end_npc = 0,scene = 10008,x = 4827,y = 7905,content_type = 1,id = 10001076,num = 20};
get_type_task_dynamic(501301,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501301,slv=570, elv=9999,start_npc = 100947,end_npc = 0,scene = 10008,x = 2689,y = 4185,content_type = 1,id = 10001079,num = 20};
get_type_task_dynamic(501302,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501302,slv=570, elv=9999,start_npc = 100949,end_npc = 0,scene = 10008,x = 1277,y = 3579,content_type = 1,id = 10001080,num = 20};
get_type_task_dynamic(501303,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501303,slv=570, elv=9999,start_npc = 100936,end_npc = 0,scene = 10008,x = 5611,y = 2831,content_type = 11,id = 38801,num = 1};
get_type_task_dynamic(501304,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501304,slv=570, elv=9999,start_npc = 100939,end_npc = 0,scene = 10008,x = 1787,y = 6047,content_type = 11,id = 38804,num = 1};
get_type_task_dynamic(501305,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501305,slv=570, elv=9999,start_npc = 100947,end_npc = 0,scene = 10008,x = 7583,y = 685,content_type = 11,id = 38802,num = 1};
get_type_task_dynamic(501306,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501306,slv=570, elv=9999,start_npc = 100949,end_npc = 0,scene = 10008,x = 7002,y = 7160,content_type = 11,id = 38803,num = 1};
get_type_task_dynamic(501307,Lv) when Lv >= 570 andalso Lv =< 9999->
    #task_lv_dynamic_content{task_id=501307,slv=570, elv=9999,start_npc = 100949,end_npc = 0,scene = 10008,x = 7002,y = 7160,content_type = 11,id = 38803,num = 1};
get_type_task_dynamic(600001,Lv) when Lv >= 1 andalso Lv =< 999->
    #task_lv_dynamic_content{task_id=600001,slv=1, elv=999,start_npc = 0,end_npc = 0,scene = 38022,x = 7140,y = 2510,content_type = 71,id = 380220,num = 2};
get_type_task_dynamic(600002,Lv) when Lv >= 1 andalso Lv =< 999->
    #task_lv_dynamic_content{task_id=600002,slv=1, elv=999,start_npc = 0,end_npc = 0,scene = 38022,x = 7140,y = 2510,content_type = 96,id = 380220,num = 500};
get_type_task_dynamic(600003,Lv) when Lv >= 1 andalso Lv =< 999->
    #task_lv_dynamic_content{task_id=600003,slv=1, elv=999,start_npc = 0,end_npc = 0,scene = 38022,x = 7140,y = 2510,content_type = 97,id = 380220,num = 1};
get_type_task_dynamic(600011,Lv) when Lv >= 1 andalso Lv =< 999->
    #task_lv_dynamic_content{task_id=600011,slv=1, elv=999,start_npc = 0,end_npc = 0,scene = 38022,x = 7140,y = 2510,content_type = 71,id = 380220,num = 2};
get_type_task_dynamic(600012,Lv) when Lv >= 1 andalso Lv =< 999->
    #task_lv_dynamic_content{task_id=600012,slv=1, elv=999,start_npc = 0,end_npc = 0,scene = 38022,x = 7140,y = 2510,content_type = 96,id = 380220,num = 500};
get_type_task_dynamic(600013,Lv) when Lv >= 1 andalso Lv =< 999->
    #task_lv_dynamic_content{task_id=600013,slv=1, elv=999,start_npc = 0,end_npc = 0,scene = 38022,x = 7140,y = 2510,content_type = 97,id = 380220,num = 1};
get_type_task_dynamic(900001,12001) ->
    #task_lv_dynamic_content{task_id=900001,slv=12001, elv=12001,start_npc = 0,end_npc = 0,scene = 12001,x = 2795,y = 5940,content_type = 1,id = 2101101,num = 40};
get_type_task_dynamic(900002,12001) ->
    #task_lv_dynamic_content{task_id=900002,slv=12001, elv=12001,start_npc = 0,end_npc = 0,scene = 12001,x = 2771,y = 3160,content_type = 1,id = 2101102,num = 40};
get_type_task_dynamic(900003,12001) ->
    #task_lv_dynamic_content{task_id=900003,slv=12001, elv=12001,start_npc = 0,end_npc = 0,scene = 12001,x = 4299,y = 6632,content_type = 1,id = 2101103,num = 40};
get_type_task_dynamic(900004,12001) ->
    #task_lv_dynamic_content{task_id=900004,slv=12001, elv=12001,start_npc = 0,end_npc = 0,scene = 12001,x = 2771,y = 3160,content_type = 3,id = 38190007,num = 20};
get_type_task_dynamic(900005,12001) ->
    #task_lv_dynamic_content{task_id=900005,slv=12001, elv=12001,start_npc = 0,end_npc = 0,scene = 12001,x = 4299,y = 6632,content_type = 3,id = 38190008,num = 20};
get_type_task_dynamic(900006,12001) ->
    #task_lv_dynamic_content{task_id=900006,slv=12001, elv=12001,start_npc = 0,end_npc = 0,scene = 12001,x = 6436,y = 6811,content_type = 3,id = 38190009,num = 20};
get_type_task_dynamic(900007,12001) ->
    #task_lv_dynamic_content{task_id=900007,slv=12001, elv=12001,start_npc = 0,end_npc = 0,scene = 12001,x = 1704,y = 6338,content_type = 4,id = 2101201,num = 3};
get_type_task_dynamic(900008,12001) ->
    #task_lv_dynamic_content{task_id=900008,slv=12001, elv=12001,start_npc = 0,end_npc = 0,scene = 12001,x = 8633,y = 2410,content_type = 4,id = 2101202,num = 3};
get_type_task_dynamic(900009,12001) ->
    #task_lv_dynamic_content{task_id=900009,slv=12001, elv=12001,start_npc = 0,end_npc = 0,scene = 12001,x = 5686,y = 2564,content_type = 4,id = 2101203,num = 3};
get_type_task_dynamic(900010,12001) ->
    #task_lv_dynamic_content{task_id=900010,slv=12001, elv=12001,start_npc = 0,end_npc = 0,scene = 12001,x = 2068,y = 1097,content_type = 4,id = 2101204,num = 3};
get_type_task_dynamic(900011,12002) ->
    #task_lv_dynamic_content{task_id=900011,slv=12002, elv=12002,start_npc = 0,end_npc = 0,scene = 12002,x = 2795,y = 5940,content_type = 1,id = 2101111,num = 40};
get_type_task_dynamic(900012,12002) ->
    #task_lv_dynamic_content{task_id=900012,slv=12002, elv=12002,start_npc = 0,end_npc = 0,scene = 12002,x = 2771,y = 3160,content_type = 1,id = 2101112,num = 40};
get_type_task_dynamic(900013,12002) ->
    #task_lv_dynamic_content{task_id=900013,slv=12002, elv=12002,start_npc = 0,end_npc = 0,scene = 12002,x = 4299,y = 6632,content_type = 1,id = 2101113,num = 40};
get_type_task_dynamic(900014,12002) ->
    #task_lv_dynamic_content{task_id=900014,slv=12002, elv=12002,start_npc = 0,end_npc = 0,scene = 12002,x = 6436,y = 6811,content_type = 3,id = 38190007,num = 20};
get_type_task_dynamic(900015,12002) ->
    #task_lv_dynamic_content{task_id=900015,slv=12002, elv=12002,start_npc = 0,end_npc = 0,scene = 12002,x = 7565,y = 6540,content_type = 3,id = 38190008,num = 20};
get_type_task_dynamic(900016,12002) ->
    #task_lv_dynamic_content{task_id=900016,slv=12002, elv=12002,start_npc = 0,end_npc = 0,scene = 12002,x = 572,y = 2810,content_type = 3,id = 38190009,num = 20};
get_type_task_dynamic(900017,12002) ->
    #task_lv_dynamic_content{task_id=900017,slv=12002, elv=12002,start_npc = 0,end_npc = 0,scene = 12002,x = 1704,y = 6338,content_type = 4,id = 2101206,num = 3};
get_type_task_dynamic(900018,12002) ->
    #task_lv_dynamic_content{task_id=900018,slv=12002, elv=12002,start_npc = 0,end_npc = 0,scene = 12002,x = 8473,y = 2507,content_type = 4,id = 2101207,num = 3};
get_type_task_dynamic(900019,12002) ->
    #task_lv_dynamic_content{task_id=900019,slv=12002, elv=12002,start_npc = 0,end_npc = 0,scene = 12002,x = 5722,y = 2677,content_type = 4,id = 2101208,num = 3};
get_type_task_dynamic(900020,12002) ->
    #task_lv_dynamic_content{task_id=900020,slv=12002, elv=12002,start_npc = 0,end_npc = 0,scene = 12002,x = 2068,y = 1097,content_type = 4,id = 2101209,num = 3};
get_type_task_dynamic(900021,12003) ->
    #task_lv_dynamic_content{task_id=900021,slv=12003, elv=12003,start_npc = 0,end_npc = 0,scene = 12003,x = 2795,y = 5940,content_type = 1,id = 2101121,num = 40};
get_type_task_dynamic(900022,12003) ->
    #task_lv_dynamic_content{task_id=900022,slv=12003, elv=12003,start_npc = 0,end_npc = 0,scene = 12003,x = 2771,y = 3160,content_type = 1,id = 2101122,num = 40};
get_type_task_dynamic(900023,12003) ->
    #task_lv_dynamic_content{task_id=900023,slv=12003, elv=12003,start_npc = 0,end_npc = 0,scene = 12003,x = 4299,y = 6632,content_type = 1,id = 2101123,num = 40};
get_type_task_dynamic(900024,12003) ->
    #task_lv_dynamic_content{task_id=900024,slv=12003, elv=12003,start_npc = 0,end_npc = 0,scene = 12003,x = 6436,y = 6811,content_type = 3,id = 38190007,num = 20};
get_type_task_dynamic(900025,12003) ->
    #task_lv_dynamic_content{task_id=900025,slv=12003, elv=12003,start_npc = 0,end_npc = 0,scene = 12003,x = 7565,y = 6540,content_type = 3,id = 38190008,num = 20};
get_type_task_dynamic(900026,12003) ->
    #task_lv_dynamic_content{task_id=900026,slv=12003, elv=12003,start_npc = 0,end_npc = 0,scene = 12003,x = 572,y = 2810,content_type = 3,id = 38190009,num = 20};
get_type_task_dynamic(900027,12003) ->
    #task_lv_dynamic_content{task_id=900027,slv=12003, elv=12003,start_npc = 0,end_npc = 0,scene = 12003,x = 1704,y = 6338,content_type = 4,id = 2101211,num = 3};
get_type_task_dynamic(900028,12003) ->
    #task_lv_dynamic_content{task_id=900028,slv=12003, elv=12003,start_npc = 0,end_npc = 0,scene = 12003,x = 8473,y = 2507,content_type = 4,id = 2101212,num = 3};
get_type_task_dynamic(900029,12003) ->
    #task_lv_dynamic_content{task_id=900029,slv=12003, elv=12003,start_npc = 0,end_npc = 0,scene = 12003,x = 5722,y = 2677,content_type = 4,id = 2101213,num = 3};
get_type_task_dynamic(900030,12003) ->
    #task_lv_dynamic_content{task_id=900030,slv=12003, elv=12003,start_npc = 0,end_npc = 0,scene = 12003,x = 2068,y = 1097,content_type = 4,id = 2101214,num = 3};
get_type_task_dynamic(_TaskType,_Lv) ->
    [].

