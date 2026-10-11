%%%---------------------------------------
%%% module      : data_wedding
%%% description : 婚姻婚礼配置
%%%
%%%---------------------------------------
-module(data_wedding).
-compile(export_all).
-include("marriage.hrl").



get_wedding_card_con(_) ->
	[].

get_wedding_info_con(1) ->
	#wedding_info_con{type = 1,name = <<"1"/utf8>>,wedding_name = <<"普通婚礼"/utf8>>,cost = [],reward = [],wedding_fail_return = [],designation_id = 0,guest_num = 50,guest_num_max = 70,time = 15,exp_time = 5,exp_coefficient = 750};

get_wedding_info_con(2) ->
	#wedding_info_con{type = 2,name = <<"2"/utf8>>,wedding_name = <<"豪华婚礼"/utf8>>,cost = [],reward = [],wedding_fail_return = [],designation_id = 0,guest_num = 50,guest_num_max = 70,time = 15,exp_time = 5,exp_coefficient = 1000};

get_wedding_info_con(3) ->
	#wedding_info_con{type = 3,name = <<"3"/utf8>>,wedding_name = <<"简约婚礼"/utf8>>,cost = [],reward = [],wedding_fail_return = [],designation_id = 0,guest_num = 50,guest_num_max = 70,time = 15,exp_time = 5,exp_coefficient = 500};

get_wedding_info_con(_Type) ->
	[].

get_wedding_designation_id_list() ->
[0].

get_wedding_time_con(1) ->
	#wedding_time_con{time_id = 1,begin_time = {8, 30},end_time = {8, 45}};

get_wedding_time_con(2) ->
	#wedding_time_con{time_id = 2,begin_time = {9, 30},end_time = {9, 45}};

get_wedding_time_con(3) ->
	#wedding_time_con{time_id = 3,begin_time = {10, 30},end_time = {10, 45}};

get_wedding_time_con(4) ->
	#wedding_time_con{time_id = 4,begin_time = {11, 30},end_time = {11, 45}};

get_wedding_time_con(5) ->
	#wedding_time_con{time_id = 5,begin_time = {13, 30},end_time = {13, 45}};

get_wedding_time_con(6) ->
	#wedding_time_con{time_id = 6,begin_time = {14, 30},end_time = {14, 45}};

get_wedding_time_con(7) ->
	#wedding_time_con{time_id = 7,begin_time = {15, 30},end_time = {15, 45}};

get_wedding_time_con(8) ->
	#wedding_time_con{time_id = 8,begin_time = {16, 30},end_time = {16, 45}};

get_wedding_time_con(9) ->
	#wedding_time_con{time_id = 9,begin_time = {17, 30},end_time = {17, 45}};

get_wedding_time_con(10) ->
	#wedding_time_con{time_id = 10,begin_time = {18, 30},end_time = {18, 45}};

get_wedding_time_con(11) ->
	#wedding_time_con{time_id = 11,begin_time = {21, 30},end_time = {21, 45}};

get_wedding_time_con(12) ->
	#wedding_time_con{time_id = 12,begin_time = {22, 0},end_time = {22, 15}};

get_wedding_time_con(_Timeid) ->
	[].

get_wedding_time_id_list() ->
[1,2,3,4,5,6,7,8,9,10,11,12].

get_wedding_time_stage_con(1) ->
	#wedding_time_stage_con{stage_id = 1,stage_name = "1",continue_time = 420,test = "宾客入场"};

get_wedding_time_stage_con(2) ->
	#wedding_time_stage_con{stage_id = 2,stage_name = "2",continue_time = 180,test = "婚礼仪式"};

get_wedding_time_stage_con(3) ->
	#wedding_time_stage_con{stage_id = 3,stage_name = "3",continue_time = 300,test = "美味佳肴"};

get_wedding_time_stage_con(_Stageid) ->
	[].

get_wedding_stage_list() ->
[{1,420},{2,180},{3,300}].

get_wedding_position(2001) ->
	#wedding_position_con{pos_id = 2001,type = 2,x = 1611,y = 2263};

get_wedding_position(2002) ->
	#wedding_position_con{pos_id = 2002,type = 2,x = 2069,y = 2438};

get_wedding_position(2003) ->
	#wedding_position_con{pos_id = 2003,type = 2,x = 2143,y = 2427};

get_wedding_position(2004) ->
	#wedding_position_con{pos_id = 2004,type = 2,x = 2080,y = 2235};

get_wedding_position(2005) ->
	#wedding_position_con{pos_id = 2005,type = 2,x = 2034,y = 2245};

get_wedding_position(2006) ->
	#wedding_position_con{pos_id = 2006,type = 2,x = 1845,y = 2175};

get_wedding_position(2007) ->
	#wedding_position_con{pos_id = 2007,type = 2,x = 1831,y = 2273};

get_wedding_position(2008) ->
	#wedding_position_con{pos_id = 2008,type = 2,x = 1985,y = 2445};

get_wedding_position(2009) ->
	#wedding_position_con{pos_id = 2009,type = 2,x = 2059,y = 2361};

get_wedding_position(2010) ->
	#wedding_position_con{pos_id = 2010,type = 2,x = 1947,y = 2354};

get_wedding_position(2011) ->
	#wedding_position_con{pos_id = 2011,type = 2,x = 1702,y = 2469};

get_wedding_position(2012) ->
	#wedding_position_con{pos_id = 2012,type = 2,x = 1737,y = 2305};

get_wedding_position(2013) ->
	#wedding_position_con{pos_id = 2013,type = 2,x = 1814,y = 2525};

get_wedding_position(2014) ->
	#wedding_position_con{pos_id = 2014,type = 2,x = 1712,y = 2455};

get_wedding_position(2015) ->
	#wedding_position_con{pos_id = 2015,type = 2,x = 2220,y = 2574};

get_wedding_position(2016) ->
	#wedding_position_con{pos_id = 2016,type = 2,x = 2300,y = 2462};

get_wedding_position(2017) ->
	#wedding_position_con{pos_id = 2017,type = 2,x = 2164,y = 2413};

get_wedding_position(2018) ->
	#wedding_position_con{pos_id = 2018,type = 2,x = 2129,y = 2592};

get_wedding_position(2019) ->
	#wedding_position_con{pos_id = 2019,type = 2,x = 2440,y = 2599};

get_wedding_position(2020) ->
	#wedding_position_con{pos_id = 2020,type = 2,x = 2454,y = 2515};

get_wedding_position(2021) ->
	#wedding_position_con{pos_id = 2021,type = 2,x = 1807,y = 2497};

get_wedding_position(2022) ->
	#wedding_position_con{pos_id = 2022,type = 2,x = 1635,y = 2095};

get_wedding_position(2023) ->
	#wedding_position_con{pos_id = 2023,type = 2,x = 1971,y = 2364};

get_wedding_position(2024) ->
	#wedding_position_con{pos_id = 2024,type = 2,x = 1509,y = 2224};

get_wedding_position(2025) ->
	#wedding_position_con{pos_id = 2025,type = 2,x = 1684,y = 2287};

get_wedding_position(2026) ->
	#wedding_position_con{pos_id = 2026,type = 2,x = 1436,y = 2403};

get_wedding_position(2027) ->
	#wedding_position_con{pos_id = 2027,type = 2,x = 2115,y = 2585};

get_wedding_position(2028) ->
	#wedding_position_con{pos_id = 2028,type = 2,x = 2825,y = 2074};

get_wedding_position(2029) ->
	#wedding_position_con{pos_id = 2029,type = 2,x = 2493,y = 1475};

get_wedding_position(2030) ->
	#wedding_position_con{pos_id = 2030,type = 2,x = 2881,y = 1720};

get_wedding_position(2031) ->
	#wedding_position_con{pos_id = 2031,type = 2,x = 2580,y = 1895};

get_wedding_position(2032) ->
	#wedding_position_con{pos_id = 2032,type = 2,x = 2902,y = 1601};

get_wedding_position(2033) ->
	#wedding_position_con{pos_id = 2033,type = 2,x = 2419,y = 1552};

get_wedding_position(2034) ->
	#wedding_position_con{pos_id = 2034,type = 2,x = 2762,y = 1717};

get_wedding_position(2035) ->
	#wedding_position_con{pos_id = 2035,type = 2,x = 3147,y = 1836};

get_wedding_position(2036) ->
	#wedding_position_con{pos_id = 2036,type = 2,x = 3028,y = 1825};

get_wedding_position(2037) ->
	#wedding_position_con{pos_id = 2037,type = 2,x = 3515,y = 1962};

get_wedding_position(2038) ->
	#wedding_position_con{pos_id = 2038,type = 2,x = 3480,y = 2088};

get_wedding_position(2039) ->
	#wedding_position_con{pos_id = 2039,type = 2,x = 3480,y = 1902};

get_wedding_position(2040) ->
	#wedding_position_con{pos_id = 2040,type = 2,x = 3480,y = 2133};

get_wedding_position(2041) ->
	#wedding_position_con{pos_id = 2041,type = 2,x = 3277,y = 1965};

get_wedding_position(2042) ->
	#wedding_position_con{pos_id = 2042,type = 2,x = 3214,y = 1951};

get_wedding_position(2043) ->
	#wedding_position_con{pos_id = 2043,type = 2,x = 2930,y = 1871};

get_wedding_position(2044) ->
	#wedding_position_con{pos_id = 2044,type = 2,x = 3378,y = 2070};

get_wedding_position(2045) ->
	#wedding_position_con{pos_id = 2045,type = 2,x = 2815,y = 1790};

get_wedding_position(2046) ->
	#wedding_position_con{pos_id = 2046,type = 2,x = 2636,y = 1748};

get_wedding_position(2047) ->
	#wedding_position_con{pos_id = 2047,type = 2,x = 2503,y = 1650};

get_wedding_position(2048) ->
	#wedding_position_con{pos_id = 2048,type = 2,x = 2276,y = 1619};

get_wedding_position(2049) ->
	#wedding_position_con{pos_id = 2049,type = 2,x = 2524,y = 1790};

get_wedding_position(2050) ->
	#wedding_position_con{pos_id = 2050,type = 2,x = 2496,y = 1668};

get_wedding_position(2051) ->
	#wedding_position_con{pos_id = 2051,type = 2,x = 2402,y = 1741};

get_wedding_position(2052) ->
	#wedding_position_con{pos_id = 2052,type = 2,x = 2384,y = 1780};

get_wedding_position(2053) ->
	#wedding_position_con{pos_id = 2053,type = 2,x = 2636,y = 1818};

get_wedding_position(2054) ->
	#wedding_position_con{pos_id = 2054,type = 2,x = 2808,y = 1857};

get_wedding_position(2055) ->
	#wedding_position_con{pos_id = 2055,type = 2,x = 2580,y = 1871};

get_wedding_position(2056) ->
	#wedding_position_con{pos_id = 2056,type = 2,x = 2475,y = 1857};

get_wedding_position(2057) ->
	#wedding_position_con{pos_id = 2057,type = 2,x = 2871,y = 2028};

get_wedding_position(2058) ->
	#wedding_position_con{pos_id = 2058,type = 2,x = 2909,y = 2532};

get_wedding_position(2059) ->
	#wedding_position_con{pos_id = 2059,type = 2,x = 2640,y = 2613};

get_wedding_position(2060) ->
	#wedding_position_con{pos_id = 2060,type = 2,x = 3235,y = 2872};

get_wedding_position(2061) ->
	#wedding_position_con{pos_id = 2061,type = 2,x = 3329,y = 2704};

get_wedding_position(2062) ->
	#wedding_position_con{pos_id = 2062,type = 2,x = 3427,y = 2333};

get_wedding_position(2063) ->
	#wedding_position_con{pos_id = 2063,type = 2,x = 2808,y = 2207};

get_wedding_position(2064) ->
	#wedding_position_con{pos_id = 2064,type = 2,x = 3284,y = 2382};

get_wedding_position(2065) ->
	#wedding_position_con{pos_id = 2065,type = 2,x = 3630,y = 2179};

get_wedding_position(2066) ->
	#wedding_position_con{pos_id = 2066,type = 2,x = 3704,y = 2098};

get_wedding_position(2067) ->
	#wedding_position_con{pos_id = 2067,type = 2,x = 3172,y = 1906};

get_wedding_position(2068) ->
	#wedding_position_con{pos_id = 2068,type = 2,x = 3049,y = 1612};

get_wedding_position(2069) ->
	#wedding_position_con{pos_id = 2069,type = 2,x = 3137,y = 2168};

get_wedding_position(2070) ->
	#wedding_position_con{pos_id = 2070,type = 2,x = 3308,y = 2151};

get_wedding_position(2071) ->
	#wedding_position_con{pos_id = 2071,type = 2,x = 3011,y = 2007};

get_wedding_position(2072) ->
	#wedding_position_con{pos_id = 2072,type = 2,x = 2927,y = 2081};

get_wedding_position(2073) ->
	#wedding_position_con{pos_id = 2073,type = 2,x = 2780,y = 1965};

get_wedding_position(2074) ->
	#wedding_position_con{pos_id = 2074,type = 2,x = 3207,y = 2151};

get_wedding_position(2075) ->
	#wedding_position_con{pos_id = 2075,type = 2,x = 3459,y = 2252};

get_wedding_position(2076) ->
	#wedding_position_con{pos_id = 2076,type = 2,x = 2913,y = 2105};

get_wedding_position(2077) ->
	#wedding_position_con{pos_id = 2077,type = 2,x = 3091,y = 2042};

get_wedding_position(2078) ->
	#wedding_position_con{pos_id = 2078,type = 2,x = 2759,y = 1615};

get_wedding_position(2079) ->
	#wedding_position_con{pos_id = 2079,type = 2,x = 2727,y = 1542};

get_wedding_position(2080) ->
	#wedding_position_con{pos_id = 2080,type = 2,x = 2979,y = 1580};

get_wedding_position(2081) ->
	#wedding_position_con{pos_id = 2081,type = 2,x = 2678,y = 1444};

get_wedding_position(2082) ->
	#wedding_position_con{pos_id = 2082,type = 2,x = 2622,y = 1398};

get_wedding_position(2083) ->
	#wedding_position_con{pos_id = 2083,type = 2,x = 3553,y = 1923};

get_wedding_position(2084) ->
	#wedding_position_con{pos_id = 2084,type = 2,x = 3515,y = 1920};

get_wedding_position(2085) ->
	#wedding_position_con{pos_id = 2085,type = 2,x = 2975,y = 1707};

get_wedding_position(2086) ->
	#wedding_position_con{pos_id = 2086,type = 2,x = 2893,y = 1681};

get_wedding_position(2087) ->
	#wedding_position_con{pos_id = 2087,type = 2,x = 3082,y = 1711};

get_wedding_position(2088) ->
	#wedding_position_con{pos_id = 2088,type = 2,x = 3311,y = 1824};

get_wedding_position(2089) ->
	#wedding_position_con{pos_id = 2089,type = 2,x = 3379,y = 1834};

get_wedding_position(2090) ->
	#wedding_position_con{pos_id = 2090,type = 2,x = 2786,y = 1615};

get_wedding_position(2091) ->
	#wedding_position_con{pos_id = 2091,type = 2,x = 2653,y = 1563};

get_wedding_position(2092) ->
	#wedding_position_con{pos_id = 2092,type = 2,x = 2600,y = 1570};

get_wedding_position(2093) ->
	#wedding_position_con{pos_id = 2093,type = 2,x = 2573,y = 1552};

get_wedding_position(2094) ->
	#wedding_position_con{pos_id = 2094,type = 2,x = 2615,y = 1657};

get_wedding_position(2095) ->
	#wedding_position_con{pos_id = 2095,type = 2,x = 2659,y = 1707};

get_wedding_position(2096) ->
	#wedding_position_con{pos_id = 2096,type = 2,x = 2524,y = 1735};

get_wedding_position(2097) ->
	#wedding_position_con{pos_id = 2097,type = 2,x = 2588,y = 1584};

get_wedding_position(2098) ->
	#wedding_position_con{pos_id = 2098,type = 2,x = 2374,y = 1531};

get_wedding_position(2099) ->
	#wedding_position_con{pos_id = 2099,type = 2,x = 2303,y = 1635};

get_wedding_position(2100) ->
	#wedding_position_con{pos_id = 2100,type = 2,x = 2279,y = 1716};

get_wedding_position(2101) ->
	#wedding_position_con{pos_id = 2101,type = 2,x = 2266,y = 1722};

get_wedding_position(2102) ->
	#wedding_position_con{pos_id = 2102,type = 2,x = 2333,y = 1507};

get_wedding_position(2103) ->
	#wedding_position_con{pos_id = 2103,type = 2,x = 2281,y = 1497};

get_wedding_position(2104) ->
	#wedding_position_con{pos_id = 2104,type = 2,x = 2135,y = 2122};

get_wedding_position(2105) ->
	#wedding_position_con{pos_id = 2105,type = 2,x = 1942,y = 2070};

get_wedding_position(2106) ->
	#wedding_position_con{pos_id = 2106,type = 2,x = 2032,y = 1992};

get_wedding_position(2107) ->
	#wedding_position_con{pos_id = 2107,type = 2,x = 2074,y = 2145};

get_wedding_position(2108) ->
	#wedding_position_con{pos_id = 2108,type = 2,x = 1915,y = 2050};

get_wedding_position(2109) ->
	#wedding_position_con{pos_id = 2109,type = 2,x = 2342,y = 2323};

get_wedding_position(2110) ->
	#wedding_position_con{pos_id = 2110,type = 2,x = 2572,y = 2418};

get_wedding_position(2111) ->
	#wedding_position_con{pos_id = 2111,type = 2,x = 2689,y = 2443};

get_wedding_position(2112) ->
	#wedding_position_con{pos_id = 2112,type = 2,x = 2738,y = 2500};

get_wedding_position(2113) ->
	#wedding_position_con{pos_id = 2113,type = 2,x = 2417,y = 2368};

get_wedding_position(2114) ->
	#wedding_position_con{pos_id = 2114,type = 2,x = 2371,y = 2323};

get_wedding_position(2115) ->
	#wedding_position_con{pos_id = 2115,type = 2,x = 2150,y = 2263};

get_wedding_position(2116) ->
	#wedding_position_con{pos_id = 2116,type = 2,x = 2728,y = 2568};

get_wedding_position(2117) ->
	#wedding_position_con{pos_id = 2117,type = 2,x = 2906,y = 2596};

get_wedding_position(2118) ->
	#wedding_position_con{pos_id = 2118,type = 2,x = 2779,y = 2491};

get_wedding_position(2119) ->
	#wedding_position_con{pos_id = 2119,type = 2,x = 2363,y = 2266};

get_wedding_position(2120) ->
	#wedding_position_con{pos_id = 2120,type = 2,x = 2272,y = 2217};

get_wedding_position(2121) ->
	#wedding_position_con{pos_id = 2121,type = 2,x = 2477,y = 2305};

get_wedding_position(2122) ->
	#wedding_position_con{pos_id = 2122,type = 2,x = 2441,y = 2317};

get_wedding_position(2123) ->
	#wedding_position_con{pos_id = 2123,type = 2,x = 2107,y = 2128};

get_wedding_position(2124) ->
	#wedding_position_con{pos_id = 2124,type = 2,x = 2014,y = 2098};

get_wedding_position(2125) ->
	#wedding_position_con{pos_id = 2125,type = 2,x = 2200,y = 2589};

get_wedding_position(2126) ->
	#wedding_position_con{pos_id = 2126,type = 2,x = 1882,y = 2479};

get_wedding_position(2127) ->
	#wedding_position_con{pos_id = 2127,type = 2,x = 2572,y = 2727};

get_wedding_position(2128) ->
	#wedding_position_con{pos_id = 2128,type = 2,x = 2269,y = 2629};

get_wedding_position(2129) ->
	#wedding_position_con{pos_id = 2129,type = 2,x = 1990,y = 2539};

get_wedding_position(2130) ->
	#wedding_position_con{pos_id = 2130,type = 2,x = 2558,y = 2910};

get_wedding_position(2131) ->
	#wedding_position_con{pos_id = 2131,type = 2,x = 2719,y = 2950};

get_wedding_position(2132) ->
	#wedding_position_con{pos_id = 2132,type = 2,x = 2795,y = 2758};

get_wedding_position(2133) ->
	#wedding_position_con{pos_id = 2133,type = 2,x = 2792,y = 2676};

get_wedding_position(2134) ->
	#wedding_position_con{pos_id = 2134,type = 2,x = 3046,y = 2706};

get_wedding_position(2135) ->
	#wedding_position_con{pos_id = 2135,type = 2,x = 3100,y = 2659};

get_wedding_position(2136) ->
	#wedding_position_con{pos_id = 2136,type = 2,x = 2975,y = 2631};

get_wedding_position(2137) ->
	#wedding_position_con{pos_id = 2137,type = 2,x = 3178,y = 2800};

get_wedding_position(2138) ->
	#wedding_position_con{pos_id = 2138,type = 2,x = 2998,y = 2886};

get_wedding_position(2139) ->
	#wedding_position_con{pos_id = 2139,type = 2,x = 3026,y = 2724};

get_wedding_position(2140) ->
	#wedding_position_con{pos_id = 2140,type = 2,x = 3020,y = 2860};

get_wedding_position(2141) ->
	#wedding_position_con{pos_id = 2141,type = 2,x = 3082,y = 2734};

get_wedding_position(2142) ->
	#wedding_position_con{pos_id = 2142,type = 2,x = 2866,y = 2688};

get_wedding_position(2143) ->
	#wedding_position_con{pos_id = 2143,type = 2,x = 2734,y = 2721};

get_wedding_position(2144) ->
	#wedding_position_con{pos_id = 2144,type = 2,x = 2768,y = 2763};

get_wedding_position(2145) ->
	#wedding_position_con{pos_id = 2145,type = 2,x = 2873,y = 2793};

get_wedding_position(2146) ->
	#wedding_position_con{pos_id = 2146,type = 2,x = 2911,y = 2788};

get_wedding_position(2147) ->
	#wedding_position_con{pos_id = 2147,type = 2,x = 2825,y = 2770};

get_wedding_position(2148) ->
	#wedding_position_con{pos_id = 2148,type = 2,x = 2668,y = 2805};

get_wedding_position(2149) ->
	#wedding_position_con{pos_id = 2149,type = 2,x = 2639,y = 2817};

get_wedding_position(2150) ->
	#wedding_position_con{pos_id = 2150,type = 2,x = 2945,y = 2878};

get_wedding_position(2151) ->
	#wedding_position_con{pos_id = 2151,type = 2,x = 3055,y = 3012};

get_wedding_position(2152) ->
	#wedding_position_con{pos_id = 2152,type = 2,x = 2755,y = 2998};

get_wedding_position(2153) ->
	#wedding_position_con{pos_id = 2153,type = 2,x = 2600,y = 2796};

get_wedding_position(2154) ->
	#wedding_position_con{pos_id = 2154,type = 2,x = 2831,y = 2836};

get_wedding_position(2155) ->
	#wedding_position_con{pos_id = 2155,type = 2,x = 2548,y = 2776};

get_wedding_position(2156) ->
	#wedding_position_con{pos_id = 2156,type = 2,x = 2560,y = 2811};

get_wedding_position(2157) ->
	#wedding_position_con{pos_id = 2157,type = 2,x = 2287,y = 2739};

get_wedding_position(2158) ->
	#wedding_position_con{pos_id = 2158,type = 2,x = 2476,y = 2815};

get_wedding_position(2159) ->
	#wedding_position_con{pos_id = 2159,type = 2,x = 2588,y = 2743};

get_wedding_position(2160) ->
	#wedding_position_con{pos_id = 2160,type = 2,x = 2425,y = 2655};

get_wedding_position(2161) ->
	#wedding_position_con{pos_id = 2161,type = 2,x = 2191,y = 2686};

get_wedding_position(2162) ->
	#wedding_position_con{pos_id = 2162,type = 2,x = 2374,y = 2676};

get_wedding_position(2163) ->
	#wedding_position_con{pos_id = 2163,type = 2,x = 2375,y = 2778};

get_wedding_position(2164) ->
	#wedding_position_con{pos_id = 2164,type = 2,x = 2455,y = 2803};

get_wedding_position(2165) ->
	#wedding_position_con{pos_id = 2165,type = 2,x = 2300,y = 2764};

get_wedding_position(2166) ->
	#wedding_position_con{pos_id = 2166,type = 2,x = 2338,y = 2865};

get_wedding_position(2167) ->
	#wedding_position_con{pos_id = 2167,type = 2,x = 2645,y = 2974};

get_wedding_position(2168) ->
	#wedding_position_con{pos_id = 2168,type = 2,x = 2483,y = 3000};

get_wedding_position(2169) ->
	#wedding_position_con{pos_id = 2169,type = 2,x = 2914,y = 3076};

get_wedding_position(2170) ->
	#wedding_position_con{pos_id = 2170,type = 2,x = 2900,y = 2971};

get_wedding_position(2171) ->
	#wedding_position_con{pos_id = 2171,type = 2,x = 2639,y = 2898};

get_wedding_position(2172) ->
	#wedding_position_con{pos_id = 2172,type = 2,x = 2933,y = 2964};

get_wedding_position(2173) ->
	#wedding_position_con{pos_id = 2173,type = 2,x = 2615,y = 3009};

get_wedding_position(2174) ->
	#wedding_position_con{pos_id = 2174,type = 2,x = 2281,y = 2827};

get_wedding_position(2175) ->
	#wedding_position_con{pos_id = 2175,type = 2,x = 1987,y = 2605};

get_wedding_position(2176) ->
	#wedding_position_con{pos_id = 2176,type = 2,x = 2500,y = 3006};

get_wedding_position(2177) ->
	#wedding_position_con{pos_id = 2177,type = 2,x = 1991,y = 2656};

get_wedding_position(2178) ->
	#wedding_position_con{pos_id = 2178,type = 2,x = 2260,y = 2890};

get_wedding_position(2179) ->
	#wedding_position_con{pos_id = 2179,type = 2,x = 2023,y = 2760};

get_wedding_position(2180) ->
	#wedding_position_con{pos_id = 2180,type = 2,x = 2017,y = 2743};

get_wedding_position(2181) ->
	#wedding_position_con{pos_id = 2181,type = 2,x = 1949,y = 2632};

get_wedding_position(2182) ->
	#wedding_position_con{pos_id = 2182,type = 2,x = 1699,y = 2517};

get_wedding_position(2183) ->
	#wedding_position_con{pos_id = 2183,type = 2,x = 1768,y = 2326};

get_wedding_position(2184) ->
	#wedding_position_con{pos_id = 2184,type = 2,x = 1826,y = 2394};

get_wedding_position(2185) ->
	#wedding_position_con{pos_id = 2185,type = 2,x = 1946,y = 2436};

get_wedding_position(2186) ->
	#wedding_position_con{pos_id = 2186,type = 2,x = 2233,y = 2496};

get_wedding_position(2187) ->
	#wedding_position_con{pos_id = 2187,type = 2,x = 2395,y = 2545};

get_wedding_position(2188) ->
	#wedding_position_con{pos_id = 2188,type = 2,x = 2182,y = 2497};

get_wedding_position(2189) ->
	#wedding_position_con{pos_id = 2189,type = 2,x = 2080,y = 2485};

get_wedding_position(2190) ->
	#wedding_position_con{pos_id = 2190,type = 2,x = 1733,y = 2307};

get_wedding_position(2191) ->
	#wedding_position_con{pos_id = 2191,type = 2,x = 1516,y = 2361};

get_wedding_position(2192) ->
	#wedding_position_con{pos_id = 2192,type = 2,x = 1325,y = 2256};

get_wedding_position(2193) ->
	#wedding_position_con{pos_id = 2193,type = 2,x = 1276,y = 2079};

get_wedding_position(2194) ->
	#wedding_position_con{pos_id = 2194,type = 2,x = 1520,y = 2064};

get_wedding_position(2195) ->
	#wedding_position_con{pos_id = 2195,type = 2,x = 1399,y = 2190};

get_wedding_position(2196) ->
	#wedding_position_con{pos_id = 2196,type = 2,x = 1543,y = 2136};

get_wedding_position(2197) ->
	#wedding_position_con{pos_id = 2197,type = 2,x = 1735,y = 2101};

get_wedding_position(2198) ->
	#wedding_position_con{pos_id = 2198,type = 2,x = 1768,y = 2022};

get_wedding_position(2199) ->
	#wedding_position_con{pos_id = 2199,type = 2,x = 1699,y = 1956};

get_wedding_position(2200) ->
	#wedding_position_con{pos_id = 2200,type = 2,x = 1741,y = 2178};

get_wedding_position(2201) ->
	#wedding_position_con{pos_id = 2201,type = 2,x = 1711,y = 2163};

get_wedding_position(2202) ->
	#wedding_position_con{pos_id = 2202,type = 2,x = 1834,y = 2211};

get_wedding_position(2203) ->
	#wedding_position_con{pos_id = 2203,type = 2,x = 1490,y = 2164};

get_wedding_position(2204) ->
	#wedding_position_con{pos_id = 2204,type = 2,x = 1316,y = 2266};

get_wedding_position(2205) ->
	#wedding_position_con{pos_id = 2205,type = 2,x = 1237,y = 2244};

get_wedding_position(2206) ->
	#wedding_position_con{pos_id = 2206,type = 2,x = 1490,y = 2332};

get_wedding_position(2207) ->
	#wedding_position_con{pos_id = 2207,type = 2,x = 1423,y = 2226};

get_wedding_position(2208) ->
	#wedding_position_con{pos_id = 2208,type = 2,x = 1364,y = 2307};

get_wedding_position(2209) ->
	#wedding_position_con{pos_id = 2209,type = 2,x = 1306,y = 2361};

get_wedding_position(2210) ->
	#wedding_position_con{pos_id = 2210,type = 2,x = 1175,y = 2274};

get_wedding_position(2211) ->
	#wedding_position_con{pos_id = 2211,type = 2,x = 1171,y = 2121};

get_wedding_position(2212) ->
	#wedding_position_con{pos_id = 2212,type = 2,x = 1211,y = 2139};

get_wedding_position(2213) ->
	#wedding_position_con{pos_id = 2213,type = 2,x = 1298,y = 2127};

get_wedding_position(2214) ->
	#wedding_position_con{pos_id = 2214,type = 2,x = 1325,y = 2016};

get_wedding_position(2215) ->
	#wedding_position_con{pos_id = 2215,type = 2,x = 1142,y = 2190};

get_wedding_position(2216) ->
	#wedding_position_con{pos_id = 2216,type = 2,x = 1187,y = 2287};

get_wedding_position(2217) ->
	#wedding_position_con{pos_id = 2217,type = 2,x = 1400,y = 2490};

get_wedding_position(2218) ->
	#wedding_position_con{pos_id = 2218,type = 2,x = 1675,y = 2577};

get_wedding_position(2219) ->
	#wedding_position_con{pos_id = 2219,type = 2,x = 1513,y = 2554};

get_wedding_position(2220) ->
	#wedding_position_con{pos_id = 2220,type = 2,x = 1342,y = 2380};

get_wedding_position(2221) ->
	#wedding_position_con{pos_id = 2221,type = 2,x = 1217,y = 2289};

get_wedding_position(2222) ->
	#wedding_position_con{pos_id = 2222,type = 2,x = 1082,y = 2385};

get_wedding_position(2223) ->
	#wedding_position_con{pos_id = 2223,type = 2,x = 976,y = 2361};

get_wedding_position(2224) ->
	#wedding_position_con{pos_id = 2224,type = 2,x = 845,y = 2191};

get_wedding_position(2225) ->
	#wedding_position_con{pos_id = 2225,type = 2,x = 1015,y = 2196};

get_wedding_position(2226) ->
	#wedding_position_con{pos_id = 2226,type = 2,x = 1043,y = 2247};

get_wedding_position(2227) ->
	#wedding_position_con{pos_id = 2227,type = 2,x = 959,y = 2268};

get_wedding_position(2228) ->
	#wedding_position_con{pos_id = 2228,type = 2,x = 922,y = 2232};

get_wedding_position(2229) ->
	#wedding_position_con{pos_id = 2229,type = 2,x = 938,y = 2322};

get_wedding_position(2230) ->
	#wedding_position_con{pos_id = 2230,type = 2,x = 1196,y = 2419};

get_wedding_position(2231) ->
	#wedding_position_con{pos_id = 2231,type = 2,x = 1421,y = 2499};

get_wedding_position(2232) ->
	#wedding_position_con{pos_id = 2232,type = 2,x = 1762,y = 2646};

get_wedding_position(2233) ->
	#wedding_position_con{pos_id = 2233,type = 2,x = 1796,y = 2526};

get_wedding_position(2234) ->
	#wedding_position_con{pos_id = 2234,type = 2,x = 1631,y = 2436};

get_wedding_position(2235) ->
	#wedding_position_con{pos_id = 2235,type = 2,x = 1619,y = 2371};

get_wedding_position(2236) ->
	#wedding_position_con{pos_id = 2236,type = 2,x = 1363,y = 2475};

get_wedding_position(2237) ->
	#wedding_position_con{pos_id = 2237,type = 2,x = 1211,y = 2442};

get_wedding_position(2238) ->
	#wedding_position_con{pos_id = 2238,type = 2,x = 1328,y = 2460};

get_wedding_position(2239) ->
	#wedding_position_con{pos_id = 2239,type = 2,x = 1898,y = 2757};

get_wedding_position(2240) ->
	#wedding_position_con{pos_id = 2240,type = 2,x = 2012,y = 2787};

get_wedding_position(2241) ->
	#wedding_position_con{pos_id = 2241,type = 2,x = 1838,y = 2692};

get_wedding_position(2242) ->
	#wedding_position_con{pos_id = 2242,type = 2,x = 1804,y = 2640};

get_wedding_position(2243) ->
	#wedding_position_con{pos_id = 2243,type = 2,x = 1979,y = 2715};

get_wedding_position(2244) ->
	#wedding_position_con{pos_id = 2244,type = 2,x = 1709,y = 2638};

get_wedding_position(2245) ->
	#wedding_position_con{pos_id = 2245,type = 2,x = 1579,y = 2589};

get_wedding_position(2246) ->
	#wedding_position_con{pos_id = 2246,type = 2,x = 2194,y = 2911};

get_wedding_position(2247) ->
	#wedding_position_con{pos_id = 2247,type = 2,x = 2210,y = 2881};

get_wedding_position(2248) ->
	#wedding_position_con{pos_id = 2248,type = 2,x = 2137,y = 2793};

get_wedding_position(2249) ->
	#wedding_position_con{pos_id = 2249,type = 2,x = 2087,y = 2779};

get_wedding_position(2250) ->
	#wedding_position_con{pos_id = 2250,type = 2,x = 2204,y = 2730};

get_wedding_position(2251) ->
	#wedding_position_con{pos_id = 2251,type = 2,x = 2272,y = 2710};

get_wedding_position(2252) ->
	#wedding_position_con{pos_id = 2252,type = 2,x = 2386,y = 2569};

get_wedding_position(2253) ->
	#wedding_position_con{pos_id = 2253,type = 2,x = 2564,y = 2595};

get_wedding_position(2254) ->
	#wedding_position_con{pos_id = 2254,type = 2,x = 2647,y = 2577};

get_wedding_position(2255) ->
	#wedding_position_con{pos_id = 2255,type = 2,x = 2497,y = 2484};

get_wedding_position(2256) ->
	#wedding_position_con{pos_id = 2256,type = 2,x = 2273,y = 2332};

get_wedding_position(2257) ->
	#wedding_position_con{pos_id = 2257,type = 2,x = 2048,y = 2203};

get_wedding_position(2258) ->
	#wedding_position_con{pos_id = 2258,type = 2,x = 1849,y = 2082};

get_wedding_position(2259) ->
	#wedding_position_con{pos_id = 2259,type = 2,x = 2468,y = 2416};

get_wedding_position(2260) ->
	#wedding_position_con{pos_id = 2260,type = 2,x = 2719,y = 2566};

get_wedding_position(2261) ->
	#wedding_position_con{pos_id = 2261,type = 2,x = 2950,y = 2749};

get_wedding_position(2262) ->
	#wedding_position_con{pos_id = 2262,type = 2,x = 3053,y = 2842};

get_wedding_position(2263) ->
	#wedding_position_con{pos_id = 2263,type = 2,x = 3050,y = 2847};

get_wedding_position(2264) ->
	#wedding_position_con{pos_id = 2264,type = 2,x = 3068,y = 2772};

get_wedding_position(2265) ->
	#wedding_position_con{pos_id = 2265,type = 2,x = 2167,y = 2368};

get_wedding_position(2266) ->
	#wedding_position_con{pos_id = 2266,type = 2,x = 3481,y = 2026};

get_wedding_position(2267) ->
	#wedding_position_con{pos_id = 2267,type = 2,x = 3487,y = 2176};

get_wedding_position(2268) ->
	#wedding_position_con{pos_id = 2268,type = 2,x = 3305,y = 2178};

get_wedding_position(2269) ->
	#wedding_position_con{pos_id = 2269,type = 2,x = 3226,y = 2199};

get_wedding_position(2270) ->
	#wedding_position_con{pos_id = 2270,type = 2,x = 3352,y = 2224};

get_wedding_position(2271) ->
	#wedding_position_con{pos_id = 2271,type = 2,x = 3058,y = 1767};

get_wedding_position(2272) ->
	#wedding_position_con{pos_id = 2272,type = 2,x = 2917,y = 1824};

get_wedding_position(2273) ->
	#wedding_position_con{pos_id = 2273,type = 2,x = 3050,y = 1951};

get_wedding_position(2274) ->
	#wedding_position_con{pos_id = 2274,type = 2,x = 2924,y = 1906};

get_wedding_position(2275) ->
	#wedding_position_con{pos_id = 2275,type = 2,x = 3182,y = 1945};

get_wedding_position(2276) ->
	#wedding_position_con{pos_id = 2276,type = 2,x = 3221,y = 1804};

get_wedding_position(2277) ->
	#wedding_position_con{pos_id = 2277,type = 2,x = 2798,y = 1500};

get_wedding_position(2278) ->
	#wedding_position_con{pos_id = 2278,type = 2,x = 2621,y = 1428};

get_wedding_position(2279) ->
	#wedding_position_con{pos_id = 2279,type = 2,x = 2819,y = 1474};

get_wedding_position(2280) ->
	#wedding_position_con{pos_id = 2280,type = 2,x = 3118,y = 1704};

get_wedding_position(2281) ->
	#wedding_position_con{pos_id = 2281,type = 2,x = 3386,y = 1821};

get_wedding_position(2282) ->
	#wedding_position_con{pos_id = 2282,type = 2,x = 3286,y = 1728};

get_wedding_position(2283) ->
	#wedding_position_con{pos_id = 2283,type = 2,x = 2983,y = 1596};

get_wedding_position(2284) ->
	#wedding_position_con{pos_id = 2284,type = 2,x = 3410,y = 1788};

get_wedding_position(2285) ->
	#wedding_position_con{pos_id = 2285,type = 2,x = 3484,y = 1933};

get_wedding_position(2286) ->
	#wedding_position_con{pos_id = 2286,type = 2,x = 3206,y = 1891};

get_wedding_position(2287) ->
	#wedding_position_con{pos_id = 2287,type = 2,x = 3463,y = 1962};

get_wedding_position(2288) ->
	#wedding_position_con{pos_id = 2288,type = 2,x = 3385,y = 2043};

get_wedding_position(2289) ->
	#wedding_position_con{pos_id = 2289,type = 2,x = 3259,y = 2034};

get_wedding_position(2290) ->
	#wedding_position_con{pos_id = 2290,type = 2,x = 3419,y = 2053};

get_wedding_position(2291) ->
	#wedding_position_con{pos_id = 2291,type = 2,x = 3098,y = 1962};

get_wedding_position(2292) ->
	#wedding_position_con{pos_id = 2292,type = 2,x = 3415,y = 2005};

get_wedding_position(2293) ->
	#wedding_position_con{pos_id = 2293,type = 2,x = 3565,y = 2101};

get_wedding_position(2294) ->
	#wedding_position_con{pos_id = 2294,type = 2,x = 3610,y = 2200};

get_wedding_position(2295) ->
	#wedding_position_con{pos_id = 2295,type = 2,x = 3575,y = 2319};

get_wedding_position(2296) ->
	#wedding_position_con{pos_id = 2296,type = 2,x = 3529,y = 2236};

get_wedding_position(2297) ->
	#wedding_position_con{pos_id = 2297,type = 2,x = 3583,y = 2020};

get_wedding_position(2298) ->
	#wedding_position_con{pos_id = 2298,type = 2,x = 3589,y = 1978};

get_wedding_position(2299) ->
	#wedding_position_con{pos_id = 2299,type = 2,x = 3163,y = 1692};

get_wedding_position(2300) ->
	#wedding_position_con{pos_id = 2300,type = 2,x = 2705,y = 1578};

get_wedding_position(2301) ->
	#wedding_position_con{pos_id = 2301,type = 2,x = 2447,y = 1615};

get_wedding_position(2302) ->
	#wedding_position_con{pos_id = 2302,type = 2,x = 2218,y = 1602};

get_wedding_position(2303) ->
	#wedding_position_con{pos_id = 2303,type = 2,x = 2195,y = 1618};

get_wedding_position(2304) ->
	#wedding_position_con{pos_id = 2304,type = 2,x = 2239,y = 1677};

get_wedding_position(2305) ->
	#wedding_position_con{pos_id = 2305,type = 2,x = 2642,y = 1888};

get_wedding_position(2306) ->
	#wedding_position_con{pos_id = 2306,type = 2,x = 2714,y = 1965};

get_wedding_position(2307) ->
	#wedding_position_con{pos_id = 2307,type = 2,x = 2755,y = 1846};

get_wedding_position(2308) ->
	#wedding_position_con{pos_id = 2308,type = 2,x = 2710,y = 1771};

get_wedding_position(2309) ->
	#wedding_position_con{pos_id = 2309,type = 2,x = 2857,y = 1873};

get_wedding_position(2310) ->
	#wedding_position_con{pos_id = 2310,type = 2,x = 2870,y = 1956};

get_wedding_position(2311) ->
	#wedding_position_con{pos_id = 2311,type = 2,x = 3019,y = 1924};

get_wedding_position(2312) ->
	#wedding_position_con{pos_id = 2312,type = 2,x = 2857,y = 1912};

get_wedding_position(2313) ->
	#wedding_position_con{pos_id = 2313,type = 2,x = 2971,y = 1798};

get_wedding_position(2314) ->
	#wedding_position_con{pos_id = 2314,type = 2,x = 3152,y = 1902};

get_wedding_position(2315) ->
	#wedding_position_con{pos_id = 2315,type = 2,x = 3328,y = 1980};

get_wedding_position(2316) ->
	#wedding_position_con{pos_id = 2316,type = 2,x = 3257,y = 2086};

get_wedding_position(2317) ->
	#wedding_position_con{pos_id = 2317,type = 2,x = 3344,y = 1804};

get_wedding_position(2318) ->
	#wedding_position_con{pos_id = 2318,type = 2,x = 3382,y = 1846};

get_wedding_position(2319) ->
	#wedding_position_con{pos_id = 2319,type = 2,x = 3229,y = 1788};

get_wedding_position(2320) ->
	#wedding_position_con{pos_id = 2320,type = 2,x = 3031,y = 1651};

get_wedding_position(2321) ->
	#wedding_position_con{pos_id = 2321,type = 2,x = 2738,y = 1413};

get_wedding_position(2322) ->
	#wedding_position_con{pos_id = 2322,type = 2,x = 2677,y = 1444};

get_wedding_position(2323) ->
	#wedding_position_con{pos_id = 2323,type = 2,x = 2965,y = 1776};

get_wedding_position(2324) ->
	#wedding_position_con{pos_id = 2324,type = 2,x = 3071,y = 1966};

get_wedding_position(2325) ->
	#wedding_position_con{pos_id = 2325,type = 2,x = 3026,y = 2007};

get_wedding_position(2326) ->
	#wedding_position_con{pos_id = 2326,type = 2,x = 2911,y = 2037};

get_wedding_position(2327) ->
	#wedding_position_con{pos_id = 2327,type = 2,x = 2708,y = 1914};

get_wedding_position(2328) ->
	#wedding_position_con{pos_id = 2328,type = 2,x = 2944,y = 2028};

get_wedding_position(2329) ->
	#wedding_position_con{pos_id = 2329,type = 2,x = 2899,y = 1945};

get_wedding_position(2330) ->
	#wedding_position_con{pos_id = 2330,type = 2,x = 2570,y = 1830};

get_wedding_position(2331) ->
	#wedding_position_con{pos_id = 2331,type = 2,x = 2641,y = 1686};

get_wedding_position(2332) ->
	#wedding_position_con{pos_id = 2332,type = 2,x = 2587,y = 1656};

get_wedding_position(2333) ->
	#wedding_position_con{pos_id = 2333,type = 2,x = 2693,y = 1707};

get_wedding_position(2334) ->
	#wedding_position_con{pos_id = 2334,type = 2,x = 2644,y = 1713};

get_wedding_position(2335) ->
	#wedding_position_con{pos_id = 2335,type = 2,x = 2492,y = 1743};

get_wedding_position(2336) ->
	#wedding_position_con{pos_id = 2336,type = 2,x = 2456,y = 1783};

get_wedding_position(2337) ->
	#wedding_position_con{pos_id = 2337,type = 2,x = 2390,y = 1795};

get_wedding_position(2338) ->
	#wedding_position_con{pos_id = 2338,type = 2,x = 2212,y = 1686};

get_wedding_position(2339) ->
	#wedding_position_con{pos_id = 2339,type = 2,x = 2266,y = 1686};

get_wedding_position(4001) ->
	#wedding_position_con{pos_id = 4001,type = 3,x = 1611,y = 2263};

get_wedding_position(4002) ->
	#wedding_position_con{pos_id = 4002,type = 3,x = 2069,y = 2438};

get_wedding_position(4003) ->
	#wedding_position_con{pos_id = 4003,type = 3,x = 2143,y = 2427};

get_wedding_position(4004) ->
	#wedding_position_con{pos_id = 4004,type = 3,x = 2080,y = 2235};

get_wedding_position(4005) ->
	#wedding_position_con{pos_id = 4005,type = 3,x = 2034,y = 2245};

get_wedding_position(4006) ->
	#wedding_position_con{pos_id = 4006,type = 3,x = 1845,y = 2175};

get_wedding_position(4007) ->
	#wedding_position_con{pos_id = 4007,type = 3,x = 1831,y = 2273};

get_wedding_position(4008) ->
	#wedding_position_con{pos_id = 4008,type = 3,x = 1985,y = 2445};

get_wedding_position(4009) ->
	#wedding_position_con{pos_id = 4009,type = 3,x = 2059,y = 2361};

get_wedding_position(4010) ->
	#wedding_position_con{pos_id = 4010,type = 3,x = 1947,y = 2354};

get_wedding_position(4011) ->
	#wedding_position_con{pos_id = 4011,type = 3,x = 1702,y = 2469};

get_wedding_position(4012) ->
	#wedding_position_con{pos_id = 4012,type = 3,x = 1737,y = 2305};

get_wedding_position(4013) ->
	#wedding_position_con{pos_id = 4013,type = 3,x = 1814,y = 2525};

get_wedding_position(4014) ->
	#wedding_position_con{pos_id = 4014,type = 3,x = 1712,y = 2455};

get_wedding_position(4015) ->
	#wedding_position_con{pos_id = 4015,type = 3,x = 2220,y = 2574};

get_wedding_position(4016) ->
	#wedding_position_con{pos_id = 4016,type = 3,x = 2300,y = 2462};

get_wedding_position(4017) ->
	#wedding_position_con{pos_id = 4017,type = 3,x = 2164,y = 2413};

get_wedding_position(4018) ->
	#wedding_position_con{pos_id = 4018,type = 3,x = 2129,y = 2592};

get_wedding_position(4019) ->
	#wedding_position_con{pos_id = 4019,type = 3,x = 2440,y = 2599};

get_wedding_position(4020) ->
	#wedding_position_con{pos_id = 4020,type = 3,x = 2454,y = 2515};

get_wedding_position(4021) ->
	#wedding_position_con{pos_id = 4021,type = 3,x = 1807,y = 2497};

get_wedding_position(4022) ->
	#wedding_position_con{pos_id = 4022,type = 3,x = 1635,y = 2095};

get_wedding_position(4023) ->
	#wedding_position_con{pos_id = 4023,type = 3,x = 1971,y = 2364};

get_wedding_position(4024) ->
	#wedding_position_con{pos_id = 4024,type = 3,x = 1509,y = 2224};

get_wedding_position(4025) ->
	#wedding_position_con{pos_id = 4025,type = 3,x = 1684,y = 2287};

get_wedding_position(4026) ->
	#wedding_position_con{pos_id = 4026,type = 3,x = 1436,y = 2403};

get_wedding_position(4027) ->
	#wedding_position_con{pos_id = 4027,type = 3,x = 2115,y = 2585};

get_wedding_position(4028) ->
	#wedding_position_con{pos_id = 4028,type = 3,x = 2825,y = 2074};

get_wedding_position(4029) ->
	#wedding_position_con{pos_id = 4029,type = 3,x = 2493,y = 1475};

get_wedding_position(4030) ->
	#wedding_position_con{pos_id = 4030,type = 3,x = 2881,y = 1720};

get_wedding_position(4031) ->
	#wedding_position_con{pos_id = 4031,type = 3,x = 2580,y = 1895};

get_wedding_position(4032) ->
	#wedding_position_con{pos_id = 4032,type = 3,x = 2902,y = 1601};

get_wedding_position(4033) ->
	#wedding_position_con{pos_id = 4033,type = 3,x = 2419,y = 1552};

get_wedding_position(4034) ->
	#wedding_position_con{pos_id = 4034,type = 3,x = 2762,y = 1717};

get_wedding_position(4035) ->
	#wedding_position_con{pos_id = 4035,type = 3,x = 3147,y = 1836};

get_wedding_position(4036) ->
	#wedding_position_con{pos_id = 4036,type = 3,x = 3028,y = 1825};

get_wedding_position(4037) ->
	#wedding_position_con{pos_id = 4037,type = 3,x = 3515,y = 1962};

get_wedding_position(4038) ->
	#wedding_position_con{pos_id = 4038,type = 3,x = 3480,y = 2088};

get_wedding_position(4039) ->
	#wedding_position_con{pos_id = 4039,type = 3,x = 3480,y = 1902};

get_wedding_position(4040) ->
	#wedding_position_con{pos_id = 4040,type = 3,x = 3480,y = 2133};

get_wedding_position(4041) ->
	#wedding_position_con{pos_id = 4041,type = 3,x = 3277,y = 1965};

get_wedding_position(4042) ->
	#wedding_position_con{pos_id = 4042,type = 3,x = 3214,y = 1951};

get_wedding_position(4043) ->
	#wedding_position_con{pos_id = 4043,type = 3,x = 2930,y = 1871};

get_wedding_position(4044) ->
	#wedding_position_con{pos_id = 4044,type = 3,x = 3378,y = 2070};

get_wedding_position(4045) ->
	#wedding_position_con{pos_id = 4045,type = 3,x = 2815,y = 1790};

get_wedding_position(4046) ->
	#wedding_position_con{pos_id = 4046,type = 3,x = 2636,y = 1748};

get_wedding_position(4047) ->
	#wedding_position_con{pos_id = 4047,type = 3,x = 2503,y = 1650};

get_wedding_position(4048) ->
	#wedding_position_con{pos_id = 4048,type = 3,x = 2276,y = 1619};

get_wedding_position(4049) ->
	#wedding_position_con{pos_id = 4049,type = 3,x = 2524,y = 1790};

get_wedding_position(4050) ->
	#wedding_position_con{pos_id = 4050,type = 3,x = 2496,y = 1668};

get_wedding_position(4051) ->
	#wedding_position_con{pos_id = 4051,type = 3,x = 2402,y = 1741};

get_wedding_position(4052) ->
	#wedding_position_con{pos_id = 4052,type = 3,x = 2384,y = 1780};

get_wedding_position(4053) ->
	#wedding_position_con{pos_id = 4053,type = 3,x = 2636,y = 1818};

get_wedding_position(4054) ->
	#wedding_position_con{pos_id = 4054,type = 3,x = 2808,y = 1857};

get_wedding_position(4055) ->
	#wedding_position_con{pos_id = 4055,type = 3,x = 2580,y = 1871};

get_wedding_position(4056) ->
	#wedding_position_con{pos_id = 4056,type = 3,x = 2475,y = 1857};

get_wedding_position(4057) ->
	#wedding_position_con{pos_id = 4057,type = 3,x = 2871,y = 2028};

get_wedding_position(4058) ->
	#wedding_position_con{pos_id = 4058,type = 3,x = 2909,y = 2532};

get_wedding_position(4059) ->
	#wedding_position_con{pos_id = 4059,type = 3,x = 2640,y = 2613};

get_wedding_position(4060) ->
	#wedding_position_con{pos_id = 4060,type = 3,x = 3235,y = 2872};

get_wedding_position(4061) ->
	#wedding_position_con{pos_id = 4061,type = 3,x = 3329,y = 2704};

get_wedding_position(4062) ->
	#wedding_position_con{pos_id = 4062,type = 3,x = 3427,y = 2333};

get_wedding_position(4063) ->
	#wedding_position_con{pos_id = 4063,type = 3,x = 2808,y = 2207};

get_wedding_position(4064) ->
	#wedding_position_con{pos_id = 4064,type = 3,x = 3284,y = 2382};

get_wedding_position(4065) ->
	#wedding_position_con{pos_id = 4065,type = 3,x = 3630,y = 2179};

get_wedding_position(4066) ->
	#wedding_position_con{pos_id = 4066,type = 3,x = 3704,y = 2098};

get_wedding_position(4067) ->
	#wedding_position_con{pos_id = 4067,type = 3,x = 3172,y = 1906};

get_wedding_position(4068) ->
	#wedding_position_con{pos_id = 4068,type = 3,x = 3049,y = 1612};

get_wedding_position(4069) ->
	#wedding_position_con{pos_id = 4069,type = 3,x = 3137,y = 2168};

get_wedding_position(4070) ->
	#wedding_position_con{pos_id = 4070,type = 3,x = 3308,y = 2151};

get_wedding_position(4071) ->
	#wedding_position_con{pos_id = 4071,type = 3,x = 3011,y = 2007};

get_wedding_position(4072) ->
	#wedding_position_con{pos_id = 4072,type = 3,x = 2927,y = 2081};

get_wedding_position(4073) ->
	#wedding_position_con{pos_id = 4073,type = 3,x = 2780,y = 1965};

get_wedding_position(4074) ->
	#wedding_position_con{pos_id = 4074,type = 3,x = 3207,y = 2151};

get_wedding_position(4075) ->
	#wedding_position_con{pos_id = 4075,type = 3,x = 3459,y = 2252};

get_wedding_position(4076) ->
	#wedding_position_con{pos_id = 4076,type = 3,x = 2913,y = 2105};

get_wedding_position(4077) ->
	#wedding_position_con{pos_id = 4077,type = 3,x = 3091,y = 2042};

get_wedding_position(4078) ->
	#wedding_position_con{pos_id = 4078,type = 3,x = 2759,y = 1615};

get_wedding_position(4079) ->
	#wedding_position_con{pos_id = 4079,type = 3,x = 2727,y = 1542};

get_wedding_position(4080) ->
	#wedding_position_con{pos_id = 4080,type = 3,x = 2979,y = 1580};

get_wedding_position(4081) ->
	#wedding_position_con{pos_id = 4081,type = 3,x = 2678,y = 1444};

get_wedding_position(4082) ->
	#wedding_position_con{pos_id = 4082,type = 3,x = 2622,y = 1398};

get_wedding_position(4083) ->
	#wedding_position_con{pos_id = 4083,type = 3,x = 3553,y = 1923};

get_wedding_position(4084) ->
	#wedding_position_con{pos_id = 4084,type = 3,x = 3515,y = 1920};

get_wedding_position(4085) ->
	#wedding_position_con{pos_id = 4085,type = 3,x = 2975,y = 1707};

get_wedding_position(4086) ->
	#wedding_position_con{pos_id = 4086,type = 3,x = 2893,y = 1681};

get_wedding_position(4087) ->
	#wedding_position_con{pos_id = 4087,type = 3,x = 3082,y = 1711};

get_wedding_position(4088) ->
	#wedding_position_con{pos_id = 4088,type = 3,x = 3311,y = 1824};

get_wedding_position(4089) ->
	#wedding_position_con{pos_id = 4089,type = 3,x = 3379,y = 1834};

get_wedding_position(4090) ->
	#wedding_position_con{pos_id = 4090,type = 3,x = 2786,y = 1615};

get_wedding_position(4091) ->
	#wedding_position_con{pos_id = 4091,type = 3,x = 2653,y = 1563};

get_wedding_position(4092) ->
	#wedding_position_con{pos_id = 4092,type = 3,x = 2600,y = 1570};

get_wedding_position(4093) ->
	#wedding_position_con{pos_id = 4093,type = 3,x = 2573,y = 1552};

get_wedding_position(4094) ->
	#wedding_position_con{pos_id = 4094,type = 3,x = 2615,y = 1657};

get_wedding_position(4095) ->
	#wedding_position_con{pos_id = 4095,type = 3,x = 2659,y = 1707};

get_wedding_position(4096) ->
	#wedding_position_con{pos_id = 4096,type = 3,x = 2524,y = 1735};

get_wedding_position(4097) ->
	#wedding_position_con{pos_id = 4097,type = 3,x = 2588,y = 1584};

get_wedding_position(4098) ->
	#wedding_position_con{pos_id = 4098,type = 3,x = 2374,y = 1531};

get_wedding_position(4099) ->
	#wedding_position_con{pos_id = 4099,type = 3,x = 2303,y = 1635};

get_wedding_position(4100) ->
	#wedding_position_con{pos_id = 4100,type = 3,x = 2279,y = 1716};

get_wedding_position(4101) ->
	#wedding_position_con{pos_id = 4101,type = 3,x = 2266,y = 1722};

get_wedding_position(4102) ->
	#wedding_position_con{pos_id = 4102,type = 3,x = 2333,y = 1507};

get_wedding_position(4103) ->
	#wedding_position_con{pos_id = 4103,type = 3,x = 2281,y = 1497};

get_wedding_position(4104) ->
	#wedding_position_con{pos_id = 4104,type = 3,x = 2135,y = 2122};

get_wedding_position(4105) ->
	#wedding_position_con{pos_id = 4105,type = 3,x = 1942,y = 2070};

get_wedding_position(4106) ->
	#wedding_position_con{pos_id = 4106,type = 3,x = 2032,y = 1992};

get_wedding_position(4107) ->
	#wedding_position_con{pos_id = 4107,type = 3,x = 2074,y = 2145};

get_wedding_position(4108) ->
	#wedding_position_con{pos_id = 4108,type = 3,x = 1915,y = 2050};

get_wedding_position(4109) ->
	#wedding_position_con{pos_id = 4109,type = 3,x = 2342,y = 2323};

get_wedding_position(4110) ->
	#wedding_position_con{pos_id = 4110,type = 3,x = 2572,y = 2418};

get_wedding_position(4111) ->
	#wedding_position_con{pos_id = 4111,type = 3,x = 2689,y = 2443};

get_wedding_position(4112) ->
	#wedding_position_con{pos_id = 4112,type = 3,x = 2738,y = 2500};

get_wedding_position(4113) ->
	#wedding_position_con{pos_id = 4113,type = 3,x = 2417,y = 2368};

get_wedding_position(4114) ->
	#wedding_position_con{pos_id = 4114,type = 3,x = 2371,y = 2323};

get_wedding_position(4115) ->
	#wedding_position_con{pos_id = 4115,type = 3,x = 2150,y = 2263};

get_wedding_position(4116) ->
	#wedding_position_con{pos_id = 4116,type = 3,x = 2728,y = 2568};

get_wedding_position(4117) ->
	#wedding_position_con{pos_id = 4117,type = 3,x = 2906,y = 2596};

get_wedding_position(4118) ->
	#wedding_position_con{pos_id = 4118,type = 3,x = 2779,y = 2491};

get_wedding_position(4119) ->
	#wedding_position_con{pos_id = 4119,type = 3,x = 2363,y = 2266};

get_wedding_position(4120) ->
	#wedding_position_con{pos_id = 4120,type = 3,x = 2272,y = 2217};

get_wedding_position(4121) ->
	#wedding_position_con{pos_id = 4121,type = 3,x = 2477,y = 2305};

get_wedding_position(4122) ->
	#wedding_position_con{pos_id = 4122,type = 3,x = 2441,y = 2317};

get_wedding_position(4123) ->
	#wedding_position_con{pos_id = 4123,type = 3,x = 2107,y = 2128};

get_wedding_position(4124) ->
	#wedding_position_con{pos_id = 4124,type = 3,x = 2014,y = 2098};

get_wedding_position(4125) ->
	#wedding_position_con{pos_id = 4125,type = 3,x = 2200,y = 2589};

get_wedding_position(4126) ->
	#wedding_position_con{pos_id = 4126,type = 3,x = 1882,y = 2479};

get_wedding_position(4127) ->
	#wedding_position_con{pos_id = 4127,type = 3,x = 2572,y = 2727};

get_wedding_position(4128) ->
	#wedding_position_con{pos_id = 4128,type = 3,x = 2269,y = 2629};

get_wedding_position(4129) ->
	#wedding_position_con{pos_id = 4129,type = 3,x = 1990,y = 2539};

get_wedding_position(4130) ->
	#wedding_position_con{pos_id = 4130,type = 3,x = 2558,y = 2910};

get_wedding_position(4131) ->
	#wedding_position_con{pos_id = 4131,type = 3,x = 2719,y = 2950};

get_wedding_position(4132) ->
	#wedding_position_con{pos_id = 4132,type = 3,x = 2795,y = 2758};

get_wedding_position(4133) ->
	#wedding_position_con{pos_id = 4133,type = 3,x = 2792,y = 2676};

get_wedding_position(4134) ->
	#wedding_position_con{pos_id = 4134,type = 3,x = 3046,y = 2706};

get_wedding_position(4135) ->
	#wedding_position_con{pos_id = 4135,type = 3,x = 3100,y = 2659};

get_wedding_position(4136) ->
	#wedding_position_con{pos_id = 4136,type = 3,x = 2975,y = 2631};

get_wedding_position(4137) ->
	#wedding_position_con{pos_id = 4137,type = 3,x = 3178,y = 2800};

get_wedding_position(4138) ->
	#wedding_position_con{pos_id = 4138,type = 3,x = 2998,y = 2886};

get_wedding_position(4139) ->
	#wedding_position_con{pos_id = 4139,type = 3,x = 3026,y = 2724};

get_wedding_position(4140) ->
	#wedding_position_con{pos_id = 4140,type = 3,x = 3020,y = 2860};

get_wedding_position(4141) ->
	#wedding_position_con{pos_id = 4141,type = 3,x = 3082,y = 2734};

get_wedding_position(4142) ->
	#wedding_position_con{pos_id = 4142,type = 3,x = 2866,y = 2688};

get_wedding_position(4143) ->
	#wedding_position_con{pos_id = 4143,type = 3,x = 2734,y = 2721};

get_wedding_position(4144) ->
	#wedding_position_con{pos_id = 4144,type = 3,x = 2768,y = 2763};

get_wedding_position(4145) ->
	#wedding_position_con{pos_id = 4145,type = 3,x = 2873,y = 2793};

get_wedding_position(4146) ->
	#wedding_position_con{pos_id = 4146,type = 3,x = 2911,y = 2788};

get_wedding_position(4147) ->
	#wedding_position_con{pos_id = 4147,type = 3,x = 2825,y = 2770};

get_wedding_position(4148) ->
	#wedding_position_con{pos_id = 4148,type = 3,x = 2668,y = 2805};

get_wedding_position(4149) ->
	#wedding_position_con{pos_id = 4149,type = 3,x = 2639,y = 2817};

get_wedding_position(4150) ->
	#wedding_position_con{pos_id = 4150,type = 3,x = 2945,y = 2878};

get_wedding_position(4151) ->
	#wedding_position_con{pos_id = 4151,type = 3,x = 3055,y = 3012};

get_wedding_position(4152) ->
	#wedding_position_con{pos_id = 4152,type = 3,x = 2755,y = 2998};

get_wedding_position(4153) ->
	#wedding_position_con{pos_id = 4153,type = 3,x = 2600,y = 2796};

get_wedding_position(4154) ->
	#wedding_position_con{pos_id = 4154,type = 3,x = 2831,y = 2836};

get_wedding_position(4155) ->
	#wedding_position_con{pos_id = 4155,type = 3,x = 2548,y = 2776};

get_wedding_position(4156) ->
	#wedding_position_con{pos_id = 4156,type = 3,x = 2560,y = 2811};

get_wedding_position(4157) ->
	#wedding_position_con{pos_id = 4157,type = 3,x = 2287,y = 2739};

get_wedding_position(4158) ->
	#wedding_position_con{pos_id = 4158,type = 3,x = 2476,y = 2815};

get_wedding_position(4159) ->
	#wedding_position_con{pos_id = 4159,type = 3,x = 2588,y = 2743};

get_wedding_position(4160) ->
	#wedding_position_con{pos_id = 4160,type = 3,x = 2425,y = 2655};

get_wedding_position(4161) ->
	#wedding_position_con{pos_id = 4161,type = 3,x = 2191,y = 2686};

get_wedding_position(4162) ->
	#wedding_position_con{pos_id = 4162,type = 3,x = 2374,y = 2676};

get_wedding_position(4163) ->
	#wedding_position_con{pos_id = 4163,type = 3,x = 2375,y = 2778};

get_wedding_position(4164) ->
	#wedding_position_con{pos_id = 4164,type = 3,x = 2455,y = 2803};

get_wedding_position(4165) ->
	#wedding_position_con{pos_id = 4165,type = 3,x = 2300,y = 2764};

get_wedding_position(4166) ->
	#wedding_position_con{pos_id = 4166,type = 3,x = 2338,y = 2865};

get_wedding_position(4167) ->
	#wedding_position_con{pos_id = 4167,type = 3,x = 2645,y = 2974};

get_wedding_position(4168) ->
	#wedding_position_con{pos_id = 4168,type = 3,x = 2483,y = 3000};

get_wedding_position(4169) ->
	#wedding_position_con{pos_id = 4169,type = 3,x = 2914,y = 3076};

get_wedding_position(4170) ->
	#wedding_position_con{pos_id = 4170,type = 3,x = 2900,y = 2971};

get_wedding_position(4171) ->
	#wedding_position_con{pos_id = 4171,type = 3,x = 2639,y = 2898};

get_wedding_position(4172) ->
	#wedding_position_con{pos_id = 4172,type = 3,x = 2933,y = 2964};

get_wedding_position(4173) ->
	#wedding_position_con{pos_id = 4173,type = 3,x = 2615,y = 3009};

get_wedding_position(4174) ->
	#wedding_position_con{pos_id = 4174,type = 3,x = 2281,y = 2827};

get_wedding_position(4175) ->
	#wedding_position_con{pos_id = 4175,type = 3,x = 1987,y = 2605};

get_wedding_position(4176) ->
	#wedding_position_con{pos_id = 4176,type = 3,x = 2500,y = 3006};

get_wedding_position(4177) ->
	#wedding_position_con{pos_id = 4177,type = 3,x = 1991,y = 2656};

get_wedding_position(4178) ->
	#wedding_position_con{pos_id = 4178,type = 3,x = 2260,y = 2890};

get_wedding_position(4179) ->
	#wedding_position_con{pos_id = 4179,type = 3,x = 2023,y = 2760};

get_wedding_position(4180) ->
	#wedding_position_con{pos_id = 4180,type = 3,x = 2017,y = 2743};

get_wedding_position(4181) ->
	#wedding_position_con{pos_id = 4181,type = 3,x = 1949,y = 2632};

get_wedding_position(4182) ->
	#wedding_position_con{pos_id = 4182,type = 3,x = 1699,y = 2517};

get_wedding_position(4183) ->
	#wedding_position_con{pos_id = 4183,type = 3,x = 1768,y = 2326};

get_wedding_position(4184) ->
	#wedding_position_con{pos_id = 4184,type = 3,x = 1826,y = 2394};

get_wedding_position(4185) ->
	#wedding_position_con{pos_id = 4185,type = 3,x = 1946,y = 2436};

get_wedding_position(4186) ->
	#wedding_position_con{pos_id = 4186,type = 3,x = 2233,y = 2496};

get_wedding_position(4187) ->
	#wedding_position_con{pos_id = 4187,type = 3,x = 2395,y = 2545};

get_wedding_position(4188) ->
	#wedding_position_con{pos_id = 4188,type = 3,x = 2182,y = 2497};

get_wedding_position(4189) ->
	#wedding_position_con{pos_id = 4189,type = 3,x = 2080,y = 2485};

get_wedding_position(4190) ->
	#wedding_position_con{pos_id = 4190,type = 3,x = 1733,y = 2307};

get_wedding_position(4191) ->
	#wedding_position_con{pos_id = 4191,type = 3,x = 1516,y = 2361};

get_wedding_position(4192) ->
	#wedding_position_con{pos_id = 4192,type = 3,x = 1325,y = 2256};

get_wedding_position(4193) ->
	#wedding_position_con{pos_id = 4193,type = 3,x = 1276,y = 2079};

get_wedding_position(4194) ->
	#wedding_position_con{pos_id = 4194,type = 3,x = 1520,y = 2064};

get_wedding_position(4195) ->
	#wedding_position_con{pos_id = 4195,type = 3,x = 1399,y = 2190};

get_wedding_position(4196) ->
	#wedding_position_con{pos_id = 4196,type = 3,x = 1543,y = 2136};

get_wedding_position(4197) ->
	#wedding_position_con{pos_id = 4197,type = 3,x = 1735,y = 2101};

get_wedding_position(4198) ->
	#wedding_position_con{pos_id = 4198,type = 3,x = 1768,y = 2022};

get_wedding_position(4199) ->
	#wedding_position_con{pos_id = 4199,type = 3,x = 1699,y = 1956};

get_wedding_position(4200) ->
	#wedding_position_con{pos_id = 4200,type = 3,x = 1741,y = 2178};

get_wedding_position(4201) ->
	#wedding_position_con{pos_id = 4201,type = 3,x = 1711,y = 2163};

get_wedding_position(4202) ->
	#wedding_position_con{pos_id = 4202,type = 3,x = 1834,y = 2211};

get_wedding_position(4203) ->
	#wedding_position_con{pos_id = 4203,type = 3,x = 1490,y = 2164};

get_wedding_position(4204) ->
	#wedding_position_con{pos_id = 4204,type = 3,x = 1316,y = 2266};

get_wedding_position(4205) ->
	#wedding_position_con{pos_id = 4205,type = 3,x = 1237,y = 2244};

get_wedding_position(4206) ->
	#wedding_position_con{pos_id = 4206,type = 3,x = 1490,y = 2332};

get_wedding_position(4207) ->
	#wedding_position_con{pos_id = 4207,type = 3,x = 1423,y = 2226};

get_wedding_position(4208) ->
	#wedding_position_con{pos_id = 4208,type = 3,x = 1364,y = 2307};

get_wedding_position(4209) ->
	#wedding_position_con{pos_id = 4209,type = 3,x = 1306,y = 2361};

get_wedding_position(4210) ->
	#wedding_position_con{pos_id = 4210,type = 3,x = 1175,y = 2274};

get_wedding_position(4211) ->
	#wedding_position_con{pos_id = 4211,type = 3,x = 1171,y = 2121};

get_wedding_position(4212) ->
	#wedding_position_con{pos_id = 4212,type = 3,x = 1211,y = 2139};

get_wedding_position(4213) ->
	#wedding_position_con{pos_id = 4213,type = 3,x = 1298,y = 2127};

get_wedding_position(4214) ->
	#wedding_position_con{pos_id = 4214,type = 3,x = 1325,y = 2016};

get_wedding_position(4215) ->
	#wedding_position_con{pos_id = 4215,type = 3,x = 1142,y = 2190};

get_wedding_position(4216) ->
	#wedding_position_con{pos_id = 4216,type = 3,x = 1187,y = 2287};

get_wedding_position(4217) ->
	#wedding_position_con{pos_id = 4217,type = 3,x = 1400,y = 2490};

get_wedding_position(4218) ->
	#wedding_position_con{pos_id = 4218,type = 3,x = 1675,y = 2577};

get_wedding_position(4219) ->
	#wedding_position_con{pos_id = 4219,type = 3,x = 1513,y = 2554};

get_wedding_position(4220) ->
	#wedding_position_con{pos_id = 4220,type = 3,x = 1342,y = 2380};

get_wedding_position(4221) ->
	#wedding_position_con{pos_id = 4221,type = 3,x = 1217,y = 2289};

get_wedding_position(4222) ->
	#wedding_position_con{pos_id = 4222,type = 3,x = 1082,y = 2385};

get_wedding_position(4223) ->
	#wedding_position_con{pos_id = 4223,type = 3,x = 976,y = 2361};

get_wedding_position(4224) ->
	#wedding_position_con{pos_id = 4224,type = 3,x = 845,y = 2191};

get_wedding_position(4225) ->
	#wedding_position_con{pos_id = 4225,type = 3,x = 1015,y = 2196};

get_wedding_position(4226) ->
	#wedding_position_con{pos_id = 4226,type = 3,x = 1043,y = 2247};

get_wedding_position(4227) ->
	#wedding_position_con{pos_id = 4227,type = 3,x = 959,y = 2268};

get_wedding_position(4228) ->
	#wedding_position_con{pos_id = 4228,type = 3,x = 922,y = 2232};

get_wedding_position(4229) ->
	#wedding_position_con{pos_id = 4229,type = 3,x = 938,y = 2322};

get_wedding_position(4230) ->
	#wedding_position_con{pos_id = 4230,type = 3,x = 1196,y = 2419};

get_wedding_position(4231) ->
	#wedding_position_con{pos_id = 4231,type = 3,x = 1421,y = 2499};

get_wedding_position(4232) ->
	#wedding_position_con{pos_id = 4232,type = 3,x = 1762,y = 2646};

get_wedding_position(4233) ->
	#wedding_position_con{pos_id = 4233,type = 3,x = 1796,y = 2526};

get_wedding_position(4234) ->
	#wedding_position_con{pos_id = 4234,type = 3,x = 1631,y = 2436};

get_wedding_position(4235) ->
	#wedding_position_con{pos_id = 4235,type = 3,x = 1619,y = 2371};

get_wedding_position(4236) ->
	#wedding_position_con{pos_id = 4236,type = 3,x = 1363,y = 2475};

get_wedding_position(4237) ->
	#wedding_position_con{pos_id = 4237,type = 3,x = 1211,y = 2442};

get_wedding_position(4238) ->
	#wedding_position_con{pos_id = 4238,type = 3,x = 1328,y = 2460};

get_wedding_position(4239) ->
	#wedding_position_con{pos_id = 4239,type = 3,x = 1898,y = 2757};

get_wedding_position(4240) ->
	#wedding_position_con{pos_id = 4240,type = 3,x = 2012,y = 2787};

get_wedding_position(4241) ->
	#wedding_position_con{pos_id = 4241,type = 3,x = 1838,y = 2692};

get_wedding_position(4242) ->
	#wedding_position_con{pos_id = 4242,type = 3,x = 1804,y = 2640};

get_wedding_position(4243) ->
	#wedding_position_con{pos_id = 4243,type = 3,x = 1979,y = 2715};

get_wedding_position(4244) ->
	#wedding_position_con{pos_id = 4244,type = 3,x = 1709,y = 2638};

get_wedding_position(4245) ->
	#wedding_position_con{pos_id = 4245,type = 3,x = 1579,y = 2589};

get_wedding_position(4246) ->
	#wedding_position_con{pos_id = 4246,type = 3,x = 2194,y = 2911};

get_wedding_position(4247) ->
	#wedding_position_con{pos_id = 4247,type = 3,x = 2210,y = 2881};

get_wedding_position(4248) ->
	#wedding_position_con{pos_id = 4248,type = 3,x = 2137,y = 2793};

get_wedding_position(4249) ->
	#wedding_position_con{pos_id = 4249,type = 3,x = 2087,y = 2779};

get_wedding_position(4250) ->
	#wedding_position_con{pos_id = 4250,type = 3,x = 2204,y = 2730};

get_wedding_position(4251) ->
	#wedding_position_con{pos_id = 4251,type = 3,x = 2272,y = 2710};

get_wedding_position(4252) ->
	#wedding_position_con{pos_id = 4252,type = 3,x = 2386,y = 2569};

get_wedding_position(4253) ->
	#wedding_position_con{pos_id = 4253,type = 3,x = 2564,y = 2595};

get_wedding_position(4254) ->
	#wedding_position_con{pos_id = 4254,type = 3,x = 2647,y = 2577};

get_wedding_position(4255) ->
	#wedding_position_con{pos_id = 4255,type = 3,x = 2497,y = 2484};

get_wedding_position(4256) ->
	#wedding_position_con{pos_id = 4256,type = 3,x = 2273,y = 2332};

get_wedding_position(4257) ->
	#wedding_position_con{pos_id = 4257,type = 3,x = 2048,y = 2203};

get_wedding_position(4258) ->
	#wedding_position_con{pos_id = 4258,type = 3,x = 1849,y = 2082};

get_wedding_position(4259) ->
	#wedding_position_con{pos_id = 4259,type = 3,x = 2468,y = 2416};

get_wedding_position(4260) ->
	#wedding_position_con{pos_id = 4260,type = 3,x = 2719,y = 2566};

get_wedding_position(4261) ->
	#wedding_position_con{pos_id = 4261,type = 3,x = 2950,y = 2749};

get_wedding_position(4262) ->
	#wedding_position_con{pos_id = 4262,type = 3,x = 3053,y = 2842};

get_wedding_position(4263) ->
	#wedding_position_con{pos_id = 4263,type = 3,x = 3050,y = 2847};

get_wedding_position(4264) ->
	#wedding_position_con{pos_id = 4264,type = 3,x = 3068,y = 2772};

get_wedding_position(4265) ->
	#wedding_position_con{pos_id = 4265,type = 3,x = 2167,y = 2368};

get_wedding_position(4266) ->
	#wedding_position_con{pos_id = 4266,type = 3,x = 3481,y = 2026};

get_wedding_position(4267) ->
	#wedding_position_con{pos_id = 4267,type = 3,x = 3487,y = 2176};

get_wedding_position(4268) ->
	#wedding_position_con{pos_id = 4268,type = 3,x = 3305,y = 2178};

get_wedding_position(4269) ->
	#wedding_position_con{pos_id = 4269,type = 3,x = 3226,y = 2199};

get_wedding_position(4270) ->
	#wedding_position_con{pos_id = 4270,type = 3,x = 3352,y = 2224};

get_wedding_position(4271) ->
	#wedding_position_con{pos_id = 4271,type = 3,x = 3058,y = 1767};

get_wedding_position(4272) ->
	#wedding_position_con{pos_id = 4272,type = 3,x = 2917,y = 1824};

get_wedding_position(4273) ->
	#wedding_position_con{pos_id = 4273,type = 3,x = 3050,y = 1951};

get_wedding_position(4274) ->
	#wedding_position_con{pos_id = 4274,type = 3,x = 2924,y = 1906};

get_wedding_position(4275) ->
	#wedding_position_con{pos_id = 4275,type = 3,x = 3182,y = 1945};

get_wedding_position(4276) ->
	#wedding_position_con{pos_id = 4276,type = 3,x = 3221,y = 1804};

get_wedding_position(4277) ->
	#wedding_position_con{pos_id = 4277,type = 3,x = 2798,y = 1500};

get_wedding_position(4278) ->
	#wedding_position_con{pos_id = 4278,type = 3,x = 2621,y = 1428};

get_wedding_position(4279) ->
	#wedding_position_con{pos_id = 4279,type = 3,x = 2819,y = 1474};

get_wedding_position(4280) ->
	#wedding_position_con{pos_id = 4280,type = 3,x = 3118,y = 1704};

get_wedding_position(4281) ->
	#wedding_position_con{pos_id = 4281,type = 3,x = 3386,y = 1821};

get_wedding_position(4282) ->
	#wedding_position_con{pos_id = 4282,type = 3,x = 3286,y = 1728};

get_wedding_position(4283) ->
	#wedding_position_con{pos_id = 4283,type = 3,x = 2983,y = 1596};

get_wedding_position(4284) ->
	#wedding_position_con{pos_id = 4284,type = 3,x = 3410,y = 1788};

get_wedding_position(4285) ->
	#wedding_position_con{pos_id = 4285,type = 3,x = 3484,y = 1933};

get_wedding_position(4286) ->
	#wedding_position_con{pos_id = 4286,type = 3,x = 3206,y = 1891};

get_wedding_position(4287) ->
	#wedding_position_con{pos_id = 4287,type = 3,x = 3463,y = 1962};

get_wedding_position(4288) ->
	#wedding_position_con{pos_id = 4288,type = 3,x = 3385,y = 2043};

get_wedding_position(4289) ->
	#wedding_position_con{pos_id = 4289,type = 3,x = 3259,y = 2034};

get_wedding_position(4290) ->
	#wedding_position_con{pos_id = 4290,type = 3,x = 3419,y = 2053};

get_wedding_position(4291) ->
	#wedding_position_con{pos_id = 4291,type = 3,x = 3098,y = 1962};

get_wedding_position(4292) ->
	#wedding_position_con{pos_id = 4292,type = 3,x = 3415,y = 2005};

get_wedding_position(4293) ->
	#wedding_position_con{pos_id = 4293,type = 3,x = 3565,y = 2101};

get_wedding_position(4294) ->
	#wedding_position_con{pos_id = 4294,type = 3,x = 3610,y = 2200};

get_wedding_position(4295) ->
	#wedding_position_con{pos_id = 4295,type = 3,x = 3575,y = 2319};

get_wedding_position(4296) ->
	#wedding_position_con{pos_id = 4296,type = 3,x = 3529,y = 2236};

get_wedding_position(4297) ->
	#wedding_position_con{pos_id = 4297,type = 3,x = 3583,y = 2020};

get_wedding_position(4298) ->
	#wedding_position_con{pos_id = 4298,type = 3,x = 3589,y = 1978};

get_wedding_position(4299) ->
	#wedding_position_con{pos_id = 4299,type = 3,x = 3163,y = 1692};

get_wedding_position(4300) ->
	#wedding_position_con{pos_id = 4300,type = 3,x = 2705,y = 1578};

get_wedding_position(4301) ->
	#wedding_position_con{pos_id = 4301,type = 3,x = 2447,y = 1615};

get_wedding_position(4302) ->
	#wedding_position_con{pos_id = 4302,type = 3,x = 2218,y = 1602};

get_wedding_position(4303) ->
	#wedding_position_con{pos_id = 4303,type = 3,x = 2195,y = 1618};

get_wedding_position(4304) ->
	#wedding_position_con{pos_id = 4304,type = 3,x = 2239,y = 1677};

get_wedding_position(4305) ->
	#wedding_position_con{pos_id = 4305,type = 3,x = 2642,y = 1888};

get_wedding_position(4306) ->
	#wedding_position_con{pos_id = 4306,type = 3,x = 2714,y = 1965};

get_wedding_position(4307) ->
	#wedding_position_con{pos_id = 4307,type = 3,x = 2755,y = 1846};

get_wedding_position(4308) ->
	#wedding_position_con{pos_id = 4308,type = 3,x = 2710,y = 1771};

get_wedding_position(4309) ->
	#wedding_position_con{pos_id = 4309,type = 3,x = 2857,y = 1873};

get_wedding_position(4310) ->
	#wedding_position_con{pos_id = 4310,type = 3,x = 2870,y = 1956};

get_wedding_position(4311) ->
	#wedding_position_con{pos_id = 4311,type = 3,x = 3019,y = 1924};

get_wedding_position(4312) ->
	#wedding_position_con{pos_id = 4312,type = 3,x = 2857,y = 1912};

get_wedding_position(4313) ->
	#wedding_position_con{pos_id = 4313,type = 3,x = 2971,y = 1798};

get_wedding_position(4314) ->
	#wedding_position_con{pos_id = 4314,type = 3,x = 3152,y = 1902};

get_wedding_position(4315) ->
	#wedding_position_con{pos_id = 4315,type = 3,x = 3328,y = 1980};

get_wedding_position(4316) ->
	#wedding_position_con{pos_id = 4316,type = 3,x = 3257,y = 2086};

get_wedding_position(4317) ->
	#wedding_position_con{pos_id = 4317,type = 3,x = 3344,y = 1804};

get_wedding_position(4318) ->
	#wedding_position_con{pos_id = 4318,type = 3,x = 3382,y = 1846};

get_wedding_position(4319) ->
	#wedding_position_con{pos_id = 4319,type = 3,x = 3229,y = 1788};

get_wedding_position(4320) ->
	#wedding_position_con{pos_id = 4320,type = 3,x = 3031,y = 1651};

get_wedding_position(4321) ->
	#wedding_position_con{pos_id = 4321,type = 3,x = 2738,y = 1413};

get_wedding_position(4322) ->
	#wedding_position_con{pos_id = 4322,type = 3,x = 2677,y = 1444};

get_wedding_position(4323) ->
	#wedding_position_con{pos_id = 4323,type = 3,x = 2965,y = 1776};

get_wedding_position(4324) ->
	#wedding_position_con{pos_id = 4324,type = 3,x = 3071,y = 1966};

get_wedding_position(4325) ->
	#wedding_position_con{pos_id = 4325,type = 3,x = 3026,y = 2007};

get_wedding_position(4326) ->
	#wedding_position_con{pos_id = 4326,type = 3,x = 2911,y = 2037};

get_wedding_position(4327) ->
	#wedding_position_con{pos_id = 4327,type = 3,x = 2708,y = 1914};

get_wedding_position(4328) ->
	#wedding_position_con{pos_id = 4328,type = 3,x = 2944,y = 2028};

get_wedding_position(4329) ->
	#wedding_position_con{pos_id = 4329,type = 3,x = 2899,y = 1945};

get_wedding_position(4330) ->
	#wedding_position_con{pos_id = 4330,type = 3,x = 2570,y = 1830};

get_wedding_position(4331) ->
	#wedding_position_con{pos_id = 4331,type = 3,x = 2641,y = 1686};

get_wedding_position(4332) ->
	#wedding_position_con{pos_id = 4332,type = 3,x = 2587,y = 1656};

get_wedding_position(4333) ->
	#wedding_position_con{pos_id = 4333,type = 3,x = 2693,y = 1707};

get_wedding_position(4334) ->
	#wedding_position_con{pos_id = 4334,type = 3,x = 2644,y = 1713};

get_wedding_position(4335) ->
	#wedding_position_con{pos_id = 4335,type = 3,x = 2492,y = 1743};

get_wedding_position(4336) ->
	#wedding_position_con{pos_id = 4336,type = 3,x = 2456,y = 1783};

get_wedding_position(4337) ->
	#wedding_position_con{pos_id = 4337,type = 3,x = 2390,y = 1795};

get_wedding_position(4338) ->
	#wedding_position_con{pos_id = 4338,type = 3,x = 2212,y = 1686};

get_wedding_position(4339) ->
	#wedding_position_con{pos_id = 4339,type = 3,x = 2266,y = 1686};

get_wedding_position(6001) ->
	#wedding_position_con{pos_id = 6001,type = 4,x = 1890,y = 2337};

get_wedding_position(6002) ->
	#wedding_position_con{pos_id = 6002,type = 4,x = 2686,y = 1726};

get_wedding_position(6003) ->
	#wedding_position_con{pos_id = 6003,type = 4,x = 2643,y = 2795};

get_wedding_position(6004) ->
	#wedding_position_con{pos_id = 6004,type = 4,x = 3340,y = 2095};

get_wedding_position(6005) ->
	#wedding_position_con{pos_id = 6005,type = 4,x = 2206,y = 2582};

get_wedding_position(6006) ->
	#wedding_position_con{pos_id = 6006,type = 4,x = 2999,y = 1912};

get_wedding_position(7001) ->
	#wedding_position_con{pos_id = 7001,type = 5,x = 1890,y = 2337};

get_wedding_position(7002) ->
	#wedding_position_con{pos_id = 7002,type = 5,x = 2686,y = 1726};

get_wedding_position(7003) ->
	#wedding_position_con{pos_id = 7003,type = 5,x = 2643,y = 2795};

get_wedding_position(7004) ->
	#wedding_position_con{pos_id = 7004,type = 5,x = 3340,y = 2095};

get_wedding_position(7005) ->
	#wedding_position_con{pos_id = 7005,type = 5,x = 2206,y = 2582};

get_wedding_position(7006) ->
	#wedding_position_con{pos_id = 7006,type = 5,x = 2999,y = 1912};

get_wedding_position(7007) ->
	#wedding_position_con{pos_id = 7007,type = 5,x = 1645,y = 2120};

get_wedding_position(7008) ->
	#wedding_position_con{pos_id = 7008,type = 5,x = 2444,y = 1562};

get_wedding_position(8001) ->
	#wedding_position_con{pos_id = 8001,type = 6,x = 1890,y = 2337};

get_wedding_position(8002) ->
	#wedding_position_con{pos_id = 8002,type = 6,x = 2686,y = 1726};

get_wedding_position(8003) ->
	#wedding_position_con{pos_id = 8003,type = 6,x = 2643,y = 2795};

get_wedding_position(8004) ->
	#wedding_position_con{pos_id = 8004,type = 6,x = 3340,y = 2095};

get_wedding_position(_Posid) ->
	[].


get_type_pos_id_list(2) ->
[2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030,2031,2032,2033,2034,2035,2036,2037,2038,2039,2040,2041,2042,2043,2044,2045,2046,2047,2048,2049,2050,2051,2052,2053,2054,2055,2056,2057,2058,2059,2060,2061,2062,2063,2064,2065,2066,2067,2068,2069,2070,2071,2072,2073,2074,2075,2076,2077,2078,2079,2080,2081,2082,2083,2084,2085,2086,2087,2088,2089,2090,2091,2092,2093,2094,2095,2096,2097,2098,2099,2100,2101,2102,2103,2104,2105,2106,2107,2108,2109,2110,2111,2112,2113,2114,2115,2116,2117,2118,2119,2120,2121,2122,2123,2124,2125,2126,2127,2128,2129,2130,2131,2132,2133,2134,2135,2136,2137,2138,2139,2140,2141,2142,2143,2144,2145,2146,2147,2148,2149,2150,2151,2152,2153,2154,2155,2156,2157,2158,2159,2160,2161,2162,2163,2164,2165,2166,2167,2168,2169,2170,2171,2172,2173,2174,2175,2176,2177,2178,2179,2180,2181,2182,2183,2184,2185,2186,2187,2188,2189,2190,2191,2192,2193,2194,2195,2196,2197,2198,2199,2200,2201,2202,2203,2204,2205,2206,2207,2208,2209,2210,2211,2212,2213,2214,2215,2216,2217,2218,2219,2220,2221,2222,2223,2224,2225,2226,2227,2228,2229,2230,2231,2232,2233,2234,2235,2236,2237,2238,2239,2240,2241,2242,2243,2244,2245,2246,2247,2248,2249,2250,2251,2252,2253,2254,2255,2256,2257,2258,2259,2260,2261,2262,2263,2264,2265,2266,2267,2268,2269,2270,2271,2272,2273,2274,2275,2276,2277,2278,2279,2280,2281,2282,2283,2284,2285,2286,2287,2288,2289,2290,2291,2292,2293,2294,2295,2296,2297,2298,2299,2300,2301,2302,2303,2304,2305,2306,2307,2308,2309,2310,2311,2312,2313,2314,2315,2316,2317,2318,2319,2320,2321,2322,2323,2324,2325,2326,2327,2328,2329,2330,2331,2332,2333,2334,2335,2336,2337,2338,2339];


get_type_pos_id_list(3) ->
[4001,4002,4003,4004,4005,4006,4007,4008,4009,4010,4011,4012,4013,4014,4015,4016,4017,4018,4019,4020,4021,4022,4023,4024,4025,4026,4027,4028,4029,4030,4031,4032,4033,4034,4035,4036,4037,4038,4039,4040,4041,4042,4043,4044,4045,4046,4047,4048,4049,4050,4051,4052,4053,4054,4055,4056,4057,4058,4059,4060,4061,4062,4063,4064,4065,4066,4067,4068,4069,4070,4071,4072,4073,4074,4075,4076,4077,4078,4079,4080,4081,4082,4083,4084,4085,4086,4087,4088,4089,4090,4091,4092,4093,4094,4095,4096,4097,4098,4099,4100,4101,4102,4103,4104,4105,4106,4107,4108,4109,4110,4111,4112,4113,4114,4115,4116,4117,4118,4119,4120,4121,4122,4123,4124,4125,4126,4127,4128,4129,4130,4131,4132,4133,4134,4135,4136,4137,4138,4139,4140,4141,4142,4143,4144,4145,4146,4147,4148,4149,4150,4151,4152,4153,4154,4155,4156,4157,4158,4159,4160,4161,4162,4163,4164,4165,4166,4167,4168,4169,4170,4171,4172,4173,4174,4175,4176,4177,4178,4179,4180,4181,4182,4183,4184,4185,4186,4187,4188,4189,4190,4191,4192,4193,4194,4195,4196,4197,4198,4199,4200,4201,4202,4203,4204,4205,4206,4207,4208,4209,4210,4211,4212,4213,4214,4215,4216,4217,4218,4219,4220,4221,4222,4223,4224,4225,4226,4227,4228,4229,4230,4231,4232,4233,4234,4235,4236,4237,4238,4239,4240,4241,4242,4243,4244,4245,4246,4247,4248,4249,4250,4251,4252,4253,4254,4255,4256,4257,4258,4259,4260,4261,4262,4263,4264,4265,4266,4267,4268,4269,4270,4271,4272,4273,4274,4275,4276,4277,4278,4279,4280,4281,4282,4283,4284,4285,4286,4287,4288,4289,4290,4291,4292,4293,4294,4295,4296,4297,4298,4299,4300,4301,4302,4303,4304,4305,4306,4307,4308,4309,4310,4311,4312,4313,4314,4315,4316,4317,4318,4319,4320,4321,4322,4323,4324,4325,4326,4327,4328,4329,4330,4331,4332,4333,4334,4335,4336,4337,4338,4339];


get_type_pos_id_list(4) ->
[6001,6002,6003,6004,6005,6006];


get_type_pos_id_list(5) ->
[7001,7002,7003,7004,7005,7006,7007,7008];


get_type_pos_id_list(6) ->
[8001,8002,8003,8004];

get_type_pos_id_list(_Type) ->
	[].

get_wedding_trouble_maker_con(_) ->
	[].

get_trouble_maker_list() ->
[].

get_wedding_candies_con(8002003) ->
	#wedding_candies_con{candies_id = 8002003,candies_name = "普通喜糖礼盒",cost_list = [{2,0,40}],free_times = 3,candies_num = 8,reward_list = [{0,32070001,1}],aura = 40,limit_num = 20};

get_wedding_candies_con(8002004) ->
	#wedding_candies_con{candies_id = 8002004,candies_name = "豪华喜糖礼盒",cost_list = [{1,0,100}],free_times = 0,candies_num = 5,reward_list = [{0,32070002,1}],aura = 100,limit_num = 5};

get_wedding_candies_con(_Candiesid) ->
	[].

get_wedding_candies_list() ->
[8002003,8002004].

get_wedding_fires_con(1) ->
	#wedding_fires_con{fires_id = 1,fires_name = "普通烟花",cost_list = [{2,0,10}],charact = uifx_giftlv8,free_times = 0,reward_list = [{0,23020001,2}],aura = 10};

get_wedding_fires_con(2) ->
	#wedding_fires_con{fires_id = 2,fires_name = "豪华烟花",cost_list = [{2,0,100}],charact = uifx_giftlv3,free_times = 0,reward_list = [{0,23020001,20}],aura = 100};

get_wedding_fires_con(_Firesid) ->
	[].

get_wedding_fires_list() ->
[1,2].

get_wedding_table_con(8002001) ->
	#wedding_table_con{table_id = 8002001,table_name = "美食",wedding_type = 1,table_num = 6,reward_list = [{0,32010166,1}],aura = 0};

get_wedding_table_con(8002002) ->
	#wedding_table_con{table_id = 8002002,table_name = "美食",wedding_type = 2,table_num = 8,reward_list = [{0,32010167,1}],aura = 0};

get_wedding_table_con(8002005) ->
	#wedding_table_con{table_id = 8002005,table_name = "美食",wedding_type = 3,table_num = 4,reward_list = [{0,32010181,1}],aura = 0};

get_wedding_table_con(_Tableid) ->
	[].

get_wedding_table_id_list() ->
[8002001,8002002,8002005].

get_wedding_aura_con(1) ->
	#wedding_aura_con{aura_id = 1,aura_num = 1314,reward_list = [{0,23020001,5},{0,16020001,5}]};

get_wedding_aura_con(_Auraid) ->
	[].

get_wedding_aura_id_list() ->
[1].

get_wedding_guest_position_con(1) ->
	#wedding_guest_position_con{id = 1,x = 1806,y = 2389,angle = 0};

get_wedding_guest_position_con(2) ->
	#wedding_guest_position_con{id = 2,x = 2160,y = 2554,angle = 0};

get_wedding_guest_position_con(3) ->
	#wedding_guest_position_con{id = 3,x = 2262,y = 2578,angle = 0};

get_wedding_guest_position_con(4) ->
	#wedding_guest_position_con{id = 4,x = 2700,y = 2635,angle = 0};

get_wedding_guest_position_con(5) ->
	#wedding_guest_position_con{id = 5,x = 2937,y = 2683,angle = 0};

get_wedding_guest_position_con(6) ->
	#wedding_guest_position_con{id = 6,x = 2100,y = 2248,angle = 0};

get_wedding_guest_position_con(7) ->
	#wedding_guest_position_con{id = 7,x = 1815,y = 2107,angle = 0};

get_wedding_guest_position_con(8) ->
	#wedding_guest_position_con{id = 8,x = 2295,y = 2365,angle = 0};

get_wedding_guest_position_con(9) ->
	#wedding_guest_position_con{id = 9,x = 2496,y = 2416,angle = 0};

get_wedding_guest_position_con(10) ->
	#wedding_guest_position_con{id = 10,x = 2564,y = 1484,angle = 0};

get_wedding_guest_position_con(11) ->
	#wedding_guest_position_con{id = 11,x = 2964,y = 1636,angle = 0};

get_wedding_guest_position_con(12) ->
	#wedding_guest_position_con{id = 12,x = 3219,y = 1873,angle = 0};

get_wedding_guest_position_con(13) ->
	#wedding_guest_position_con{id = 13,x = 3312,y = 2038,angle = 0};

get_wedding_guest_position_con(14) ->
	#wedding_guest_position_con{id = 14,x = 3033,y = 2026,angle = 0};

get_wedding_guest_position_con(15) ->
	#wedding_guest_position_con{id = 15,x = 2760,y = 1738,angle = 0};

get_wedding_guest_position_con(16) ->
	#wedding_guest_position_con{id = 16,x = 2730,y = 1585,angle = 0};

get_wedding_guest_position_con(17) ->
	#wedding_guest_position_con{id = 17,x = 2613,y = 1813,angle = 0};

get_wedding_guest_position_con(18) ->
	#wedding_guest_position_con{id = 18,x = 2823,y = 1897,angle = 0};

get_wedding_guest_position_con(19) ->
	#wedding_guest_position_con{id = 19,x = 3267,y = 1693,angle = 0};

get_wedding_guest_position_con(20) ->
	#wedding_guest_position_con{id = 20,x = 2454,y = 1603,angle = 0};

get_wedding_guest_position_con(21) ->
	#wedding_guest_position_con{id = 21,x = 2541,y = 1777,angle = 0};

get_wedding_guest_position_con(22) ->
	#wedding_guest_position_con{id = 22,x = 3579,y = 2179,angle = 0};

get_wedding_guest_position_con(23) ->
	#wedding_guest_position_con{id = 23,x = 3561,y = 2272,angle = 0};

get_wedding_guest_position_con(24) ->
	#wedding_guest_position_con{id = 24,x = 3444,y = 2311,angle = 0};

get_wedding_guest_position_con(25) ->
	#wedding_guest_position_con{id = 25,x = 3354,y = 2221,angle = 0};

get_wedding_guest_position_con(26) ->
	#wedding_guest_position_con{id = 26,x = 1227,y = 2371,angle = 0};

get_wedding_guest_position_con(27) ->
	#wedding_guest_position_con{id = 27,x = 1500,y = 2311,angle = 0};

get_wedding_guest_position_con(28) ->
	#wedding_guest_position_con{id = 28,x = 1617,y = 2233,angle = 0};

get_wedding_guest_position_con(29) ->
	#wedding_guest_position_con{id = 29,x = 2751,y = 2881,angle = 0};

get_wedding_guest_position_con(30) ->
	#wedding_guest_position_con{id = 30,x = 3039,y = 2923,angle = 0};

get_wedding_guest_position_con(31) ->
	#wedding_guest_position_con{id = 31,x = 3150,y = 2872,angle = 0};

get_wedding_guest_position_con(32) ->
	#wedding_guest_position_con{id = 32,x = 2883,y = 2791,angle = 0};

get_wedding_guest_position_con(33) ->
	#wedding_guest_position_con{id = 33,x = 2301,y = 2842,angle = 0};

get_wedding_guest_position_con(34) ->
	#wedding_guest_position_con{id = 34,x = 2043,y = 2752,angle = 0};

get_wedding_guest_position_con(35) ->
	#wedding_guest_position_con{id = 35,x = 1707,y = 2563,angle = 0};

get_wedding_guest_position_con(36) ->
	#wedding_guest_position_con{id = 36,x = 1611,y = 2491,angle = 0};

get_wedding_guest_position_con(37) ->
	#wedding_guest_position_con{id = 37,x = 1554,y = 2530,angle = 0};

get_wedding_guest_position_con(38) ->
	#wedding_guest_position_con{id = 38,x = 1734,y = 2686,angle = 0};

get_wedding_guest_position_con(39) ->
	#wedding_guest_position_con{id = 39,x = 2358,y = 1834,angle = 0};

get_wedding_guest_position_con(40) ->
	#wedding_guest_position_con{id = 40,x = 2325,y = 1624,angle = 0};

get_wedding_guest_position_con(41) ->
	#wedding_guest_position_con{id = 41,x = 2724,y = 1465,angle = 0};

get_wedding_guest_position_con(_Id) ->
	[].

get_exp_by_lv(_Lv) ->
	0.

get_wedding_aura_and_exp(1,_Num) when _Num >= 1, _Num =< 5 ->
		[5,1000];
get_wedding_aura_and_exp(1,_Num) when _Num >= 6, _Num =< 10 ->
		[5,1100];
get_wedding_aura_and_exp(1,_Num) when _Num >= 11, _Num =< 15 ->
		[10,1300];
get_wedding_aura_and_exp(1,_Num) when _Num >= 16, _Num =< 20 ->
		[10,1500];
get_wedding_aura_and_exp(1,_Num) when _Num >= 21, _Num =< 25 ->
		[15,1600];
get_wedding_aura_and_exp(1,_Num) when _Num >= 26, _Num =< 30 ->
		[15,1700];
get_wedding_aura_and_exp(1,_Num) when _Num >= 31, _Num =< 35 ->
		[20,1800];
get_wedding_aura_and_exp(1,_Num) when _Num >= 36, _Num =< 40 ->
		[20,1900];
get_wedding_aura_and_exp(1,_Num) when _Num >= 41, _Num =< 99 ->
		[25,2000];
get_wedding_aura_and_exp(2,_Num) when _Num >= 1, _Num =< 5 ->
		[5,1000];
get_wedding_aura_and_exp(2,_Num) when _Num >= 6, _Num =< 10 ->
		[5,1100];
get_wedding_aura_and_exp(2,_Num) when _Num >= 11, _Num =< 15 ->
		[10,1300];
get_wedding_aura_and_exp(2,_Num) when _Num >= 16, _Num =< 20 ->
		[10,1500];
get_wedding_aura_and_exp(2,_Num) when _Num >= 21, _Num =< 25 ->
		[15,1600];
get_wedding_aura_and_exp(2,_Num) when _Num >= 26, _Num =< 30 ->
		[15,1700];
get_wedding_aura_and_exp(2,_Num) when _Num >= 31, _Num =< 35 ->
		[20,1800];
get_wedding_aura_and_exp(2,_Num) when _Num >= 36, _Num =< 40 ->
		[20,1900];
get_wedding_aura_and_exp(2,_Num) when _Num >= 41, _Num =< 99 ->
		[25,2000];
get_wedding_aura_and_exp(3,_Num) when _Num >= 1, _Num =< 5 ->
		[5,1000];
get_wedding_aura_and_exp(3,_Num) when _Num >= 6, _Num =< 10 ->
		[5,1100];
get_wedding_aura_and_exp(3,_Num) when _Num >= 11, _Num =< 15 ->
		[10,1300];
get_wedding_aura_and_exp(3,_Num) when _Num >= 16, _Num =< 20 ->
		[10,1500];
get_wedding_aura_and_exp(3,_Num) when _Num >= 21, _Num =< 25 ->
		[15,1600];
get_wedding_aura_and_exp(3,_Num) when _Num >= 26, _Num =< 30 ->
		[15,1700];
get_wedding_aura_and_exp(3,_Num) when _Num >= 31, _Num =< 35 ->
		[20,1800];
get_wedding_aura_and_exp(3,_Num) when _Num >= 36, _Num =< 40 ->
		[20,1900];
get_wedding_aura_and_exp(3,_Num) when _Num >= 41, _Num =< 99 ->
		[25,2000];
get_wedding_aura_and_exp(_Wedding_type,_Num) ->
	[0,0].

