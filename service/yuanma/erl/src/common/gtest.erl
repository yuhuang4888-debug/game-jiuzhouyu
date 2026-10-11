%% ---------------------------------------------------------------------------
%% @doc gtest.erl
%% @author 
%% @since  2020年10月31日
%% @deprecated 测试
%% ---------------------------------------------------------------------------
-module(gtest).
-compile(export_all).

-include("common.hrl").


%% 测试花的时间
%%  结论：
%% window 测试
% (yy3d_kfn10@192.168.4.213)5> 
% (yy3d_kfn10@192.168.4.213)5> gtest:test_dst_fun(10000).  
% tool[line: 315]: "dst1" [total: 90(1873)ms avg: 9.000(187.300)us]
% tool[line: 315]: "dst2" [total: 10(10)ms avg: 1.000(1.000)us]
% tool[line: 315]: "dst3" [total: 0(11)ms avg: 0.000(1.100)us]
% tool[line: 315]: "dst4" [total: 40(1748)ms avg: 4.000(174.800)us]
% {["dst1",90,1873,1880],
%  ["dst2",10,10,0],
%  ["dst3",0,11,101],
%  ["dst4",40,1748,1717]}
% (yy3d_kfn10@192.168.4.213)6> gtest:test_dst_fun(100000).
% tool[line: 315]: "dst1" [total: 70(17425)ms avg: 0.700(174.250)us]
% tool[line: 315]: "dst2" [total: 70(102)ms avg: 0.700(1.020)us]
% tool[line: 315]: "dst3" [total: 30(106)ms avg: 0.300(1.060)us]
% tool[line: 315]: "dst4" [total: 90(17288)ms avg: 0.900(172.880)us]
% {["dst1",70,17425,17372],
%  ["dst2",70,102,101],
%  ["dst3",30,106,101],
%  ["dst4",90,17288,17275]}
% (yy3d_kfn10@192.168.4.213)7> gtest:test_dst_fun(1000000).
% tool[line: 315]: "dst1" [total: 70(172959)ms avg: 0.070(172.959)us]
% tool[line: 315]: "dst2" [total: 50(983)ms avg: 0.050(0.983)us]
% tool[line: 315]: "dst3" [total: 30(1058)ms avg: 0.030(1.058)us]
% tool[line: 315]: "dst4" [total: 90(173215)ms avg: 0.090(173.215)us]
% {["dst1",70,172959,172912],
%  ["dst2",50,983,1010],
%  ["dst3",30,1058,1013],
%  ["dst4",90,173215,173226]}
%% 

test_dst_fun(Count) ->
    F = fun(_No) -> 
        calendar:local_time_to_universal_time_dst({{2020,11,2}, {1,1,1}})
    end,
    R1 = tool:test_sensitive_prof_timer("dst1", F, Count),
    F2 = fun(_No) -> 
        utime:unixdate()
        % Now = mod_time:now(),
        % % 获取{{year,month,day},{hour,minute,second}}
        % {_, Time} = calendar:now_to_local_time(Now),
        % % 算出当天的秒数，不管夏令时和冬令时
        % % {1,minute,second}(3600) => {2,minute,second}(7200)
        % Ds = calendar:time_to_seconds(Time),
        % {M, S, _} = Now,
        % % 当前的秒数-计算出的秒数（因为夏令时和冬令时会导致这个值波动）
        % M * 1000000 + S - Ds.
    end,
    R2 = tool:test_sensitive_prof_timer("dst2", F2, Count),
    F3 = fun(_No) -> 
        erlang:universaltime_to_posixtime(erlang:localtime_to_universaltime({{2020,11,2}, {1,1,1}}))
    end,
    R3 = tool:test_sensitive_prof_timer("dst3", F3, Count),
    F4 = fun(_No) -> 
        utime:unixtime({{2020,11,2}, {1,1,1}})
        % %% local_time_to_universal_time_dst 在liunx上效率非常低
        % [UniversalTime] = calendar:local_time_to_universal_time_dst(LocalTime), %% 带夏令时
        % %% UniversalTime = erlang:localtime_to_universaltime(LocalTime),
        % S = calendar:datetime_to_gregorian_seconds(UniversalTime),
        % max(0, S - ?DIFF_SECONDS_0000_1970).
    end,
    R4 = tool:test_sensitive_prof_timer("dst4", F4, Count),
    {R1, R2, R3, R4}.

%% 测试获取秒数: erlang:system_time(seconds) 效率更高
% (yy3d_kfn10@192.168.4.213)8> gtest:test_mod_time(10000).  
% tool[line: 315]: "1" [total: 10(7)ms avg: 1.000(0.700)us]
% tool[line: 315]: "2" [total: 0(5)ms avg: 0.000(0.500)us]
% {["1",10,7,0],["2",0,5,0]}
% (yy3d_kfn10@192.168.4.213)9> gtest:test_mod_time(1000000).
% tool[line: 315]: "1" [total: 30(192)ms avg: 0.030(0.192)us]
% tool[line: 315]: "2" [total: 10(90)ms avg: 0.010(0.090)us]
% {["1",30,192,202],["2",10,90,101]}
% (yy3d_kfn10@192.168.4.213)10> gtest:test_mod_time(10000000).
% tool[line: 315]: "1" [total: 90(1362)ms avg: 0.009(0.136)us]
% tool[line: 315]: "2" [total: 70(887)ms avg: 0.007(0.089)us]
% {["1",90,1362,1313],["2",70,887,909]}
test_mod_time(Count) ->
    F = fun(_No) -> 
        mod_time:now()
        % {M, S, _} = mod_time:now(),
        % M * 1000000 + S.
    end,
    R1 = tool:test_sensitive_prof_timer("1", F, Count),
    F2 = fun(_No) ->
        erlang:system_time(seconds)
    end,
    R2 = tool:test_sensitive_prof_timer("2", F2, Count),
    {R1, R2}.

% linux
% (yy3d_kfn10@192.168.4.213)1> gtest:test_open_day(10000).
% tool[line: 315]: "1" [total: 10(4)ms avg: 1.000(0.400)us]
% tool[line: 315]: "2" [total: 10(12)ms avg: 1.000(1.200)us]
% tool[line: 315]: "3" [total: 30(23)ms avg: 3.000(2.300)us]
% {["1",10,4,0],["2",10,12,0],["3",30,23,0]}
% (yy3d_kfn10@192.168.4.213)2> gtest:test_open_day(100000).
% tool[line: 315]: "1" [total: 90(102)ms avg: 0.900(1.020)us]
% tool[line: 315]: "2" [total: 60(164)ms avg: 0.600(1.640)us]
% tool[line: 315]: "3" [total: 50(204)ms avg: 0.500(2.040)us]
% {["1",90,102,101],["2",60,164,202],["3",50,204,202]}
% (yy3d_kfn10@192.168.4.213)3> gtest:test_open_day(100000).
% tool[line: 315]: "1" [total: 90(102)ms avg: 0.900(1.020)us]
% tool[line: 315]: "2" [total: 60(164)ms avg: 0.600(1.640)us]
% tool[line: 315]: "3" [total: 70(206)ms avg: 0.700(2.060)us]
% {["1",90,102,101],["2",60,164,202],["3",70,206,202]}
% (yy3d_kfn10@192.168.4.213)4> gtest:test_open_day(1000000).
% tool[line: 315]: "1" [total: 100(454)ms avg: 0.100(0.454)us]
% tool[line: 315]: "2" [total: 80(984)ms avg: 0.080(0.984)us]
% tool[line: 315]: "3" [total: 50(1991)ms avg: 0.050(1.991)us]
% {["1",100,454,404],["2",80,984,1010],["3",50,1991,2020]}
% (yy3d_kfn10@192.168.4.213)5> gtest:test_open_day(1000000).
% tool[line: 315]: "1" [total: 0(433)ms avg: 0.000(0.433)us]
% tool[line: 315]: "2" [total: 70(976)ms avg: 0.070(0.976)us]
% tool[line: 315]: "3" [total: 70(1907)ms avg: 0.070(1.907)us]
% {["1",0,433,505],["2",70,976,909],["3",70,1907,1919]}
test_open_day(Count) ->
    F = fun(_No) ->
        Now = utime:unixtime(),
        OpenTime = util:get_open_time(),
        Day = (Now - OpenTime) div 86400,
        Day + 1
    % {M, S, _} = mod_time:now(),
    % M * 1000000 + S.
        end,
    R1 = tool:test_sensitive_prof_timer("1", F, Count),
    F2 = fun(_No) ->
        Now = utime:unixdate(),
        OpenTime = util:get_open_time(),
        Day = (Now - OpenTime + 12 * ?ONE_HOUR_SECONDS) div ?ONE_DAY_SECONDS,
        max(Day + 1, 1)

    end,
    R2 = tool:test_sensitive_prof_timer("2", F2, Count),
    F3 = fun(_No) ->
        Now = utime:unixtime(),
        OpenTime = util:get_open_time(),
        DiffDay = utime:diff_days(OpenTime, Now),
        max(DiffDay + 1, 1)
    
         end,
    R3 = tool:test_sensitive_prof_timer("3", F3, Count),
    {R1, R2, R3}.