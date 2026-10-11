%%%---------------------------------------
%%% module      : data_attr_medicament
%%% description : 属性药剂配置
%%%
%%%---------------------------------------
-module(data_attr_medicament).
-compile(export_all).




get_attr_by_good_id(56010001) ->
[{1,10}];


get_attr_by_good_id(56010002) ->
[{2,200}];


get_attr_by_good_id(56010003) ->
[{3,10}];


get_attr_by_good_id(56010004) ->
[{4,10}];


get_attr_by_good_id(56020001) ->
[{1,50}];


get_attr_by_good_id(56020002) ->
[{2,1000}];


get_attr_by_good_id(56020003) ->
[{1,30},{2,400}];


get_attr_by_good_id(56020004) ->
[{3,25},{4,25}];


get_attr_by_good_id(56030001) ->
[{1,120}];


get_attr_by_good_id(56030002) ->
[{2,2400}];


get_attr_by_good_id(56030003) ->
[{1,60},{2,1200}];


get_attr_by_good_id(56030004) ->
[{3,60},{4,60}];


get_attr_by_good_id(56040001) ->
[{1,200},{3,100}];


get_attr_by_good_id(56040002) ->
[{2,4000},{4,100}];


get_attr_by_good_id(56040003) ->
[{1,150},{2,3000}];


get_attr_by_good_id(56040004) ->
[{3,150},{4,150}];

get_attr_by_good_id(_Goodid) ->
	[].


get_good_id_list_by_lv(1) ->
[56010001,56010002,56010003,56010004];


get_good_id_list_by_lv(2) ->
[56020001,56020002,56020003,56020004];


get_good_id_list_by_lv(3) ->
[56030001,56030002,56030003,56030004];


get_good_id_list_by_lv(4) ->
[56040001,56040002,56040003,56040004];

get_good_id_list_by_lv(_Lv) ->
	[].

get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,100];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,300];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,1000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,2000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,3000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,3000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,4000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,5000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,6000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,7000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,8000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,10000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,12000];
get_count_by_goodid_and_lv(56010001,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,14000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,100];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,300];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,1000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,2000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,3000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,3000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,4000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,5000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,6000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 600, _Lv =< 9999 ->
		[100,7000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,8000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,9000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,12000];
get_count_by_goodid_and_lv(56010002,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,14000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,100];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,300];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,1000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,2000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,3000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,3000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,4000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,5000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,6000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 600, _Lv =< 9999 ->
		[100,7000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,8000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,9000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,12000];
get_count_by_goodid_and_lv(56010003,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,14000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,100];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,300];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,1000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,2000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,3000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,3000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,4000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,5000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,6000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 600, _Lv =< 9999 ->
		[100,7000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,8000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 700, _Lv =< 9999 ->
		[100,9000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,12000];
get_count_by_goodid_and_lv(56010004,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,14000];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,30];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,100];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,300];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,600];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,900];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,1400];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,2000];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,2500];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,3000];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,3500];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,4000];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,5000];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,6000];
get_count_by_goodid_and_lv(56020001,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,7000];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,30];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,100];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,300];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,600];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,900];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,1400];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,2000];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,2500];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,3000];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,3500];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,4000];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,5000];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,6000];
get_count_by_goodid_and_lv(56020002,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,7000];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,30];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,100];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,300];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,600];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,900];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,1400];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,2000];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,2500];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,3000];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,3500];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,4000];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,5000];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,6000];
get_count_by_goodid_and_lv(56020003,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,7000];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,30];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,100];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,300];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,600];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,900];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,1400];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,2000];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,2500];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,3000];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,3500];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,4000];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,5000];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,6000];
get_count_by_goodid_and_lv(56020004,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,7000];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,20];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,60];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,200];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,400];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,600];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,600];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,800];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,1000];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,1200];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,1400];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,1600];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,2000];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,2400];
get_count_by_goodid_and_lv(56030001,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,2800];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,20];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,60];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,200];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,400];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,600];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,600];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,800];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,1000];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,1200];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,1400];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,1600];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,2000];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,2400];
get_count_by_goodid_and_lv(56030002,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,2800];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,20];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,60];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,200];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,400];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,600];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,600];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,800];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,1000];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,1200];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,1400];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,1600];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,2000];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,2400];
get_count_by_goodid_and_lv(56030003,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,2800];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,20];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,60];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,200];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,400];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,600];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,600];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,800];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,1000];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,1200];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,1400];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,1600];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,2000];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,2400];
get_count_by_goodid_and_lv(56030004,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,2800];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,5];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,15];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,50];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,100];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,150];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,150];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,200];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,250];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,300];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,350];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,400];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,500];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,600];
get_count_by_goodid_and_lv(56040001,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,700];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,5];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,15];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,50];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,100];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,150];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,150];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,200];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,250];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,300];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,350];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,400];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,500];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,600];
get_count_by_goodid_and_lv(56040002,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,700];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,5];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,15];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,50];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,100];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,150];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,150];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,200];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,250];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,300];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,350];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,400];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,500];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,600];
get_count_by_goodid_and_lv(56040003,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,700];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 1, _Lv =< 199 ->
		[100,5];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 200, _Lv =< 249 ->
		[100,15];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 250, _Lv =< 299 ->
		[100,50];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 300, _Lv =< 349 ->
		[100,100];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 350, _Lv =< 399 ->
		[100,150];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 400, _Lv =< 449 ->
		[100,150];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 450, _Lv =< 499 ->
		[100,200];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 500, _Lv =< 549 ->
		[100,250];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 550, _Lv =< 599 ->
		[100,300];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 600, _Lv =< 649 ->
		[100,350];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 650, _Lv =< 699 ->
		[100,400];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 700, _Lv =< 749 ->
		[100,500];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 750, _Lv =< 799 ->
		[100,600];
get_count_by_goodid_and_lv(56040004,_Lv) when _Lv >= 800, _Lv =< 9999 ->
		[100,700];
get_count_by_goodid_and_lv(_Good_id,_Lv) ->
	[].

