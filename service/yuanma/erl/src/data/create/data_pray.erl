%%%---------------------------------------
%%% module      : data_pray
%%% description : 祈愿配置
%%%
%%%---------------------------------------
-module(data_pray).
-compile(export_all).




get_cfg(1) ->
1;


get_cfg(2) ->
0;


get_cfg(3) ->
0;


get_cfg(4) ->
0;


get_cfg(5) ->
130;


get_cfg(6) ->
43200;

get_cfg(_Id) ->
	0.

get_cost(1,_Times) when _Times >= 1, _Times =< 1 ->
		[{1,0,10}];
get_cost(1,_Times) when _Times >= 2, _Times =< 2 ->
		[{1,0,10}];
get_cost(1,_Times) when _Times >= 3, _Times =< 3 ->
		[{1,0,15}];
get_cost(1,_Times) when _Times >= 4, _Times =< 4 ->
		[{1,0,20}];
get_cost(1,_Times) when _Times >= 5, _Times =< 6 ->
		[{1,0,25}];
get_cost(1,_Times) when _Times >= 7, _Times =< 8 ->
		[{1,0,30}];
get_cost(1,_Times) when _Times >= 9, _Times =< 10 ->
		[{1,0,40}];
get_cost(1,_Times) when _Times >= 11, _Times =< 13 ->
		[{1,0,50}];
get_cost(1,_Times) when _Times >= 14, _Times =< 16 ->
		[{1,0,60}];
get_cost(1,_Times) when _Times >= 17, _Times =< 19 ->
		[{1,0,70}];
get_cost(1,_Times) when _Times >= 20, _Times =< 22 ->
		[{1,0,80}];
get_cost(1,_Times) when _Times >= 23, _Times =< 25 ->
		[{1,0,90}];
get_cost(1,_Times) when _Times >= 26, _Times =< 999 ->
		[{1,0,100}];
get_cost(2,_Times) when _Times >= 1, _Times =< 1 ->
		[{1,0,10}];
get_cost(2,_Times) when _Times >= 2, _Times =< 2 ->
		[{1,0,15}];
get_cost(2,_Times) when _Times >= 3, _Times =< 3 ->
		[{1,0,20}];
get_cost(2,_Times) when _Times >= 4, _Times =< 4 ->
		[{1,0,25}];
get_cost(2,_Times) when _Times >= 5, _Times =< 6 ->
		[{1,0,30}];
get_cost(2,_Times) when _Times >= 7, _Times =< 8 ->
		[{1,0,35}];
get_cost(2,_Times) when _Times >= 9, _Times =< 10 ->
		[{1,0,40}];
get_cost(2,_Times) when _Times >= 11, _Times =< 13 ->
		[{1,0,50}];
get_cost(2,_Times) when _Times >= 14, _Times =< 16 ->
		[{1,0,60}];
get_cost(2,_Times) when _Times >= 17, _Times =< 19 ->
		[{1,0,70}];
get_cost(2,_Times) when _Times >= 20, _Times =< 22 ->
		[{1,0,80}];
get_cost(2,_Times) when _Times >= 23, _Times =< 25 ->
		[{1,0,90}];
get_cost(2,_Times) when _Times >= 26, _Times =< 100 ->
		[{1,0,100}];
get_cost(_Type,_Times) ->
	99999999.

get_crit(1,_Times) when _Times >= 1, _Times =< 1 ->
		[{600,1},{350,2},{40,3},{10,5},{0,10}];
get_crit(1,_Times) when _Times >= 2, _Times =< 2 ->
		[{580,1},{365,2},{40,3},{10,5},{5,10}];
get_crit(1,_Times) when _Times >= 3, _Times =< 3 ->
		[{560,1},{370,2},{40,3},{20,5},{10,10}];
get_crit(1,_Times) when _Times >= 4, _Times =< 4 ->
		[{540,1},{370,2},{45,3},{30,5},{15,10}];
get_crit(1,_Times) when _Times >= 5, _Times =< 6 ->
		[{520,1},{360,2},{60,3},{40,5},{20,10}];
get_crit(1,_Times) when _Times >= 7, _Times =< 8 ->
		[{500,1},{350,2},{75,3},{50,5},{25,10}];
get_crit(1,_Times) when _Times >= 9, _Times =< 10 ->
		[{480,1},{340,2},{90,3},{60,5},{30,10}];
get_crit(1,_Times) when _Times >= 11, _Times =< 13 ->
		[{460,1},{330,2},{105,3},{70,5},{35,10}];
get_crit(1,_Times) when _Times >= 14, _Times =< 16 ->
		[{440,1},{320,2},{120,3},{80,5},{40,10}];
get_crit(1,_Times) when _Times >= 17, _Times =< 19 ->
		[{420,1},{310,2},{135,3},{90,5},{45,10}];
get_crit(1,_Times) when _Times >= 20, _Times =< 22 ->
		[{400,1},{300,2},{150,3},{100,5},{50,10}];
get_crit(1,_Times) when _Times >= 23, _Times =< 25 ->
		[{380,1},{290,2},{165,3},{110,5},{55,10}];
get_crit(1,_Times) when _Times >= 26, _Times =< 999 ->
		[{360,1},{280,2},{180,3},{120,5},{60,10}];
get_crit(2,_Times) when _Times >= 1, _Times =< 1 ->
		[{600,1},{350,2},{40,3},{10,5},{0,10}];
get_crit(2,_Times) when _Times >= 2, _Times =< 2 ->
		[{580,1},{365,2},{40,3},{10,5},{5,10}];
get_crit(2,_Times) when _Times >= 3, _Times =< 3 ->
		[{560,1},{370,2},{40,3},{20,5},{10,10}];
get_crit(2,_Times) when _Times >= 4, _Times =< 4 ->
		[{540,1},{370,2},{45,3},{30,5},{15,10}];
get_crit(2,_Times) when _Times >= 5, _Times =< 6 ->
		[{520,1},{360,2},{60,3},{40,5},{20,10}];
get_crit(2,_Times) when _Times >= 7, _Times =< 8 ->
		[{500,1},{350,2},{75,3},{50,5},{25,10}];
get_crit(2,_Times) when _Times >= 9, _Times =< 10 ->
		[{480,1},{340,2},{90,3},{60,5},{30,10}];
get_crit(2,_Times) when _Times >= 11, _Times =< 13 ->
		[{460,1},{330,2},{105,3},{70,5},{35,10}];
get_crit(2,_Times) when _Times >= 14, _Times =< 16 ->
		[{440,1},{320,2},{120,3},{80,5},{40,10}];
get_crit(2,_Times) when _Times >= 17, _Times =< 19 ->
		[{420,1},{310,2},{135,3},{90,5},{45,10}];
get_crit(2,_Times) when _Times >= 20, _Times =< 22 ->
		[{400,1},{300,2},{150,3},{100,5},{50,10}];
get_crit(2,_Times) when _Times >= 23, _Times =< 25 ->
		[{380,1},{290,2},{165,3},{110,5},{55,10}];
get_crit(2,_Times) when _Times >= 26, _Times =< 100 ->
		[{360,1},{280,2},{180,3},{120,5},{60,10}];
get_crit(_Type,_Times) ->
	0.

get_reward(1,_RoleLv) when _RoleLv >= 105, _RoleLv =< 149 ->
		[{3,0,300000}];
get_reward(1,_RoleLv) when _RoleLv >= 150, _RoleLv =< 189 ->
		[{3,0,350000}];
get_reward(1,_RoleLv) when _RoleLv >= 190, _RoleLv =< 229 ->
		[{3,0,400000}];
get_reward(1,_RoleLv) when _RoleLv >= 230, _RoleLv =< 269 ->
		[{3,0,450000}];
get_reward(1,_RoleLv) when _RoleLv >= 270, _RoleLv =< 309 ->
		[{3,0,500000}];
get_reward(1,_RoleLv) when _RoleLv >= 310, _RoleLv =< 349 ->
		[{3,0,550000}];
get_reward(1,_RoleLv) when _RoleLv >= 350, _RoleLv =< 389 ->
		[{3,0,600000}];
get_reward(1,_RoleLv) when _RoleLv >= 390, _RoleLv =< 429 ->
		[{3,0,650000}];
get_reward(1,_RoleLv) when _RoleLv >= 430, _RoleLv =< 469 ->
		[{3,0,700000}];
get_reward(1,_RoleLv) when _RoleLv >= 470, _RoleLv =< 509 ->
		[{3,0,750000}];
get_reward(1,_RoleLv) when _RoleLv >= 510, _RoleLv =< 549 ->
		[{3,0,800000}];
get_reward(1,_RoleLv) when _RoleLv >= 550, _RoleLv =< 589 ->
		[{3,0,850000}];
get_reward(1,_RoleLv) when _RoleLv >= 590, _RoleLv =< 629 ->
		[{3,0,900000}];
get_reward(1,_RoleLv) when _RoleLv >= 630, _RoleLv =< 669 ->
		[{3,0,950000}];
get_reward(1,_RoleLv) when _RoleLv >= 670, _RoleLv =< 9999 ->
		[{3,0,1000000}];
get_reward(2,_RoleLv) when _RoleLv >= 105, _RoleLv =< 105 ->
		[{5,0,45481800}];
get_reward(2,_RoleLv) when _RoleLv >= 106, _RoleLv =< 106 ->
		[{5,0,46274300}];
get_reward(2,_RoleLv) when _RoleLv >= 107, _RoleLv =< 107 ->
		[{5,0,47075300}];
get_reward(2,_RoleLv) when _RoleLv >= 108, _RoleLv =< 108 ->
		[{5,0,47884800}];
get_reward(2,_RoleLv) when _RoleLv >= 109, _RoleLv =< 109 ->
		[{5,0,48702800}];
get_reward(2,_RoleLv) when _RoleLv >= 110, _RoleLv =< 110 ->
		[{5,0,49529300}];
get_reward(2,_RoleLv) when _RoleLv >= 111, _RoleLv =< 111 ->
		[{5,0,50364400}];
get_reward(2,_RoleLv) when _RoleLv >= 112, _RoleLv =< 112 ->
		[{5,0,51208200}];
get_reward(2,_RoleLv) when _RoleLv >= 113, _RoleLv =< 113 ->
		[{5,0,52060500}];
get_reward(2,_RoleLv) when _RoleLv >= 114, _RoleLv =< 114 ->
		[{5,0,52921500}];
get_reward(2,_RoleLv) when _RoleLv >= 115, _RoleLv =< 115 ->
		[{5,0,53791300}];
get_reward(2,_RoleLv) when _RoleLv >= 116, _RoleLv =< 116 ->
		[{5,0,54669800}];
get_reward(2,_RoleLv) when _RoleLv >= 117, _RoleLv =< 117 ->
		[{5,0,55557000}];
get_reward(2,_RoleLv) when _RoleLv >= 118, _RoleLv =< 118 ->
		[{5,0,56453100}];
get_reward(2,_RoleLv) when _RoleLv >= 119, _RoleLv =< 119 ->
		[{5,0,57358000}];
get_reward(2,_RoleLv) when _RoleLv >= 120, _RoleLv =< 120 ->
		[{5,0,58271800}];
get_reward(2,_RoleLv) when _RoleLv >= 121, _RoleLv =< 121 ->
		[{5,0,59194500}];
get_reward(2,_RoleLv) when _RoleLv >= 122, _RoleLv =< 122 ->
		[{5,0,60126100}];
get_reward(2,_RoleLv) when _RoleLv >= 123, _RoleLv =< 123 ->
		[{5,0,61066700}];
get_reward(2,_RoleLv) when _RoleLv >= 124, _RoleLv =< 124 ->
		[{5,0,62016200}];
get_reward(2,_RoleLv) when _RoleLv >= 125, _RoleLv =< 125 ->
		[{5,0,62974900}];
get_reward(2,_RoleLv) when _RoleLv >= 126, _RoleLv =< 126 ->
		[{5,0,63942500}];
get_reward(2,_RoleLv) when _RoleLv >= 127, _RoleLv =< 127 ->
		[{5,0,64919300}];
get_reward(2,_RoleLv) when _RoleLv >= 128, _RoleLv =< 128 ->
		[{5,0,65905200}];
get_reward(2,_RoleLv) when _RoleLv >= 129, _RoleLv =< 129 ->
		[{5,0,66900300}];
get_reward(2,_RoleLv) when _RoleLv >= 130, _RoleLv =< 130 ->
		[{5,0,67904600}];
get_reward(2,_RoleLv) when _RoleLv >= 131, _RoleLv =< 131 ->
		[{5,0,68918000}];
get_reward(2,_RoleLv) when _RoleLv >= 132, _RoleLv =< 132 ->
		[{5,0,69940800}];
get_reward(2,_RoleLv) when _RoleLv >= 133, _RoleLv =< 133 ->
		[{5,0,70972800}];
get_reward(2,_RoleLv) when _RoleLv >= 134, _RoleLv =< 134 ->
		[{5,0,72014200}];
get_reward(2,_RoleLv) when _RoleLv >= 135, _RoleLv =< 135 ->
		[{5,0,73064900}];
get_reward(2,_RoleLv) when _RoleLv >= 136, _RoleLv =< 136 ->
		[{5,0,74124900}];
get_reward(2,_RoleLv) when _RoleLv >= 137, _RoleLv =< 137 ->
		[{5,0,75194400}];
get_reward(2,_RoleLv) when _RoleLv >= 138, _RoleLv =< 138 ->
		[{5,0,76273400}];
get_reward(2,_RoleLv) when _RoleLv >= 139, _RoleLv =< 139 ->
		[{5,0,77361800}];
get_reward(2,_RoleLv) when _RoleLv >= 140, _RoleLv =< 140 ->
		[{5,0,78459700}];
get_reward(2,_RoleLv) when _RoleLv >= 141, _RoleLv =< 141 ->
		[{5,0,79567100}];
get_reward(2,_RoleLv) when _RoleLv >= 142, _RoleLv =< 142 ->
		[{5,0,80684100}];
get_reward(2,_RoleLv) when _RoleLv >= 143, _RoleLv =< 143 ->
		[{5,0,81810800}];
get_reward(2,_RoleLv) when _RoleLv >= 144, _RoleLv =< 144 ->
		[{5,0,82947000}];
get_reward(2,_RoleLv) when _RoleLv >= 145, _RoleLv =< 145 ->
		[{5,0,84092900}];
get_reward(2,_RoleLv) when _RoleLv >= 146, _RoleLv =< 146 ->
		[{5,0,85248500}];
get_reward(2,_RoleLv) when _RoleLv >= 147, _RoleLv =< 147 ->
		[{5,0,86413800}];
get_reward(2,_RoleLv) when _RoleLv >= 148, _RoleLv =< 148 ->
		[{5,0,87588900}];
get_reward(2,_RoleLv) when _RoleLv >= 149, _RoleLv =< 149 ->
		[{5,0,88773700}];
get_reward(2,_RoleLv) when _RoleLv >= 150, _RoleLv =< 150 ->
		[{5,0,89968400}];
get_reward(2,_RoleLv) when _RoleLv >= 151, _RoleLv =< 151 ->
		[{5,0,91172900}];
get_reward(2,_RoleLv) when _RoleLv >= 152, _RoleLv =< 152 ->
		[{5,0,92387300}];
get_reward(2,_RoleLv) when _RoleLv >= 153, _RoleLv =< 153 ->
		[{5,0,93611600}];
get_reward(2,_RoleLv) when _RoleLv >= 154, _RoleLv =< 154 ->
		[{5,0,94845800}];
get_reward(2,_RoleLv) when _RoleLv >= 155, _RoleLv =< 155 ->
		[{5,0,96090000}];
get_reward(2,_RoleLv) when _RoleLv >= 156, _RoleLv =< 156 ->
		[{5,0,97344100}];
get_reward(2,_RoleLv) when _RoleLv >= 157, _RoleLv =< 157 ->
		[{5,0,98608300}];
get_reward(2,_RoleLv) when _RoleLv >= 158, _RoleLv =< 158 ->
		[{5,0,99882600}];
get_reward(2,_RoleLv) when _RoleLv >= 159, _RoleLv =< 159 ->
		[{5,0,101166900}];
get_reward(2,_RoleLv) when _RoleLv >= 160, _RoleLv =< 160 ->
		[{5,0,102461300}];
get_reward(2,_RoleLv) when _RoleLv >= 161, _RoleLv =< 161 ->
		[{5,0,103765900}];
get_reward(2,_RoleLv) when _RoleLv >= 162, _RoleLv =< 162 ->
		[{5,0,105080700}];
get_reward(2,_RoleLv) when _RoleLv >= 163, _RoleLv =< 163 ->
		[{5,0,106405600}];
get_reward(2,_RoleLv) when _RoleLv >= 164, _RoleLv =< 164 ->
		[{5,0,107740800}];
get_reward(2,_RoleLv) when _RoleLv >= 165, _RoleLv =< 165 ->
		[{5,0,109086300}];
get_reward(2,_RoleLv) when _RoleLv >= 166, _RoleLv =< 166 ->
		[{5,0,110442000}];
get_reward(2,_RoleLv) when _RoleLv >= 167, _RoleLv =< 167 ->
		[{5,0,111808100}];
get_reward(2,_RoleLv) when _RoleLv >= 168, _RoleLv =< 168 ->
		[{5,0,113184500}];
get_reward(2,_RoleLv) when _RoleLv >= 169, _RoleLv =< 169 ->
		[{5,0,114571300}];
get_reward(2,_RoleLv) when _RoleLv >= 170, _RoleLv =< 170 ->
		[{5,0,115968500}];
get_reward(2,_RoleLv) when _RoleLv >= 171, _RoleLv =< 171 ->
		[{5,0,117376100}];
get_reward(2,_RoleLv) when _RoleLv >= 172, _RoleLv =< 172 ->
		[{5,0,118794200}];
get_reward(2,_RoleLv) when _RoleLv >= 173, _RoleLv =< 173 ->
		[{5,0,120222800}];
get_reward(2,_RoleLv) when _RoleLv >= 174, _RoleLv =< 174 ->
		[{5,0,121661900}];
get_reward(2,_RoleLv) when _RoleLv >= 175, _RoleLv =< 175 ->
		[{5,0,123111600}];
get_reward(2,_RoleLv) when _RoleLv >= 176, _RoleLv =< 176 ->
		[{5,0,124571800}];
get_reward(2,_RoleLv) when _RoleLv >= 177, _RoleLv =< 177 ->
		[{5,0,126042700}];
get_reward(2,_RoleLv) when _RoleLv >= 178, _RoleLv =< 178 ->
		[{5,0,127524200}];
get_reward(2,_RoleLv) when _RoleLv >= 179, _RoleLv =< 179 ->
		[{5,0,129016400}];
get_reward(2,_RoleLv) when _RoleLv >= 180, _RoleLv =< 180 ->
		[{5,0,130519200}];
get_reward(2,_RoleLv) when _RoleLv >= 181, _RoleLv =< 181 ->
		[{5,0,132032800}];
get_reward(2,_RoleLv) when _RoleLv >= 182, _RoleLv =< 182 ->
		[{5,0,133557200}];
get_reward(2,_RoleLv) when _RoleLv >= 183, _RoleLv =< 183 ->
		[{5,0,135092300}];
get_reward(2,_RoleLv) when _RoleLv >= 184, _RoleLv =< 184 ->
		[{5,0,136638200}];
get_reward(2,_RoleLv) when _RoleLv >= 185, _RoleLv =< 185 ->
		[{5,0,138195000}];
get_reward(2,_RoleLv) when _RoleLv >= 186, _RoleLv =< 186 ->
		[{5,0,139762700}];
get_reward(2,_RoleLv) when _RoleLv >= 187, _RoleLv =< 187 ->
		[{5,0,141341200}];
get_reward(2,_RoleLv) when _RoleLv >= 188, _RoleLv =< 188 ->
		[{5,0,142930700}];
get_reward(2,_RoleLv) when _RoleLv >= 189, _RoleLv =< 189 ->
		[{5,0,144531100}];
get_reward(2,_RoleLv) when _RoleLv >= 190, _RoleLv =< 190 ->
		[{5,0,146142500}];
get_reward(2,_RoleLv) when _RoleLv >= 191, _RoleLv =< 191 ->
		[{5,0,147764900}];
get_reward(2,_RoleLv) when _RoleLv >= 192, _RoleLv =< 192 ->
		[{5,0,149398300}];
get_reward(2,_RoleLv) when _RoleLv >= 193, _RoleLv =< 193 ->
		[{5,0,151042800}];
get_reward(2,_RoleLv) when _RoleLv >= 194, _RoleLv =< 194 ->
		[{5,0,152698400}];
get_reward(2,_RoleLv) when _RoleLv >= 195, _RoleLv =< 195 ->
		[{5,0,154365100}];
get_reward(2,_RoleLv) when _RoleLv >= 196, _RoleLv =< 196 ->
		[{5,0,156043000}];
get_reward(2,_RoleLv) when _RoleLv >= 197, _RoleLv =< 197 ->
		[{5,0,157732100}];
get_reward(2,_RoleLv) when _RoleLv >= 198, _RoleLv =< 198 ->
		[{5,0,159432300}];
get_reward(2,_RoleLv) when _RoleLv >= 199, _RoleLv =< 199 ->
		[{5,0,161143800}];
get_reward(2,_RoleLv) when _RoleLv >= 200, _RoleLv =< 200 ->
		[{5,0,162866500}];
get_reward(2,_RoleLv) when _RoleLv >= 201, _RoleLv =< 201 ->
		[{5,0,164600500}];
get_reward(2,_RoleLv) when _RoleLv >= 202, _RoleLv =< 202 ->
		[{5,0,166345900}];
get_reward(2,_RoleLv) when _RoleLv >= 203, _RoleLv =< 203 ->
		[{5,0,168102600}];
get_reward(2,_RoleLv) when _RoleLv >= 204, _RoleLv =< 204 ->
		[{5,0,169870600}];
get_reward(2,_RoleLv) when _RoleLv >= 205, _RoleLv =< 205 ->
		[{5,0,171650100}];
get_reward(2,_RoleLv) when _RoleLv >= 206, _RoleLv =< 206 ->
		[{5,0,173441000}];
get_reward(2,_RoleLv) when _RoleLv >= 207, _RoleLv =< 207 ->
		[{5,0,175243300}];
get_reward(2,_RoleLv) when _RoleLv >= 208, _RoleLv =< 208 ->
		[{5,0,177057100}];
get_reward(2,_RoleLv) when _RoleLv >= 209, _RoleLv =< 209 ->
		[{5,0,178882400}];
get_reward(2,_RoleLv) when _RoleLv >= 210, _RoleLv =< 210 ->
		[{5,0,180719300}];
get_reward(2,_RoleLv) when _RoleLv >= 211, _RoleLv =< 211 ->
		[{5,0,182567700}];
get_reward(2,_RoleLv) when _RoleLv >= 212, _RoleLv =< 212 ->
		[{5,0,184427700}];
get_reward(2,_RoleLv) when _RoleLv >= 213, _RoleLv =< 213 ->
		[{5,0,186299300}];
get_reward(2,_RoleLv) when _RoleLv >= 214, _RoleLv =< 214 ->
		[{5,0,188182600}];
get_reward(2,_RoleLv) when _RoleLv >= 215, _RoleLv =< 215 ->
		[{5,0,190077500}];
get_reward(2,_RoleLv) when _RoleLv >= 216, _RoleLv =< 216 ->
		[{5,0,191984100}];
get_reward(2,_RoleLv) when _RoleLv >= 217, _RoleLv =< 217 ->
		[{5,0,193902500}];
get_reward(2,_RoleLv) when _RoleLv >= 218, _RoleLv =< 218 ->
		[{5,0,195832600}];
get_reward(2,_RoleLv) when _RoleLv >= 219, _RoleLv =< 219 ->
		[{5,0,197774500}];
get_reward(2,_RoleLv) when _RoleLv >= 220, _RoleLv =< 220 ->
		[{5,0,199728100}];
get_reward(2,_RoleLv) when _RoleLv >= 221, _RoleLv =< 221 ->
		[{5,0,201693700}];
get_reward(2,_RoleLv) when _RoleLv >= 222, _RoleLv =< 222 ->
		[{5,0,203671000}];
get_reward(2,_RoleLv) when _RoleLv >= 223, _RoleLv =< 223 ->
		[{5,0,205660300}];
get_reward(2,_RoleLv) when _RoleLv >= 224, _RoleLv =< 224 ->
		[{5,0,207661500}];
get_reward(2,_RoleLv) when _RoleLv >= 225, _RoleLv =< 225 ->
		[{5,0,209674600}];
get_reward(2,_RoleLv) when _RoleLv >= 226, _RoleLv =< 226 ->
		[{5,0,211699700}];
get_reward(2,_RoleLv) when _RoleLv >= 227, _RoleLv =< 227 ->
		[{5,0,213736700}];
get_reward(2,_RoleLv) when _RoleLv >= 228, _RoleLv =< 228 ->
		[{5,0,215785800}];
get_reward(2,_RoleLv) when _RoleLv >= 229, _RoleLv =< 229 ->
		[{5,0,217846900}];
get_reward(2,_RoleLv) when _RoleLv >= 230, _RoleLv =< 230 ->
		[{5,0,219920100}];
get_reward(2,_RoleLv) when _RoleLv >= 231, _RoleLv =< 231 ->
		[{5,0,222005400}];
get_reward(2,_RoleLv) when _RoleLv >= 232, _RoleLv =< 232 ->
		[{5,0,224102900}];
get_reward(2,_RoleLv) when _RoleLv >= 233, _RoleLv =< 233 ->
		[{5,0,226212400}];
get_reward(2,_RoleLv) when _RoleLv >= 234, _RoleLv =< 234 ->
		[{5,0,228334200}];
get_reward(2,_RoleLv) when _RoleLv >= 235, _RoleLv =< 235 ->
		[{5,0,230468100}];
get_reward(2,_RoleLv) when _RoleLv >= 236, _RoleLv =< 236 ->
		[{5,0,232614300}];
get_reward(2,_RoleLv) when _RoleLv >= 237, _RoleLv =< 237 ->
		[{5,0,234772700}];
get_reward(2,_RoleLv) when _RoleLv >= 238, _RoleLv =< 238 ->
		[{5,0,236943500}];
get_reward(2,_RoleLv) when _RoleLv >= 239, _RoleLv =< 239 ->
		[{5,0,239126500}];
get_reward(2,_RoleLv) when _RoleLv >= 240, _RoleLv =< 240 ->
		[{5,0,241321800}];
get_reward(2,_RoleLv) when _RoleLv >= 241, _RoleLv =< 241 ->
		[{5,0,243529600}];
get_reward(2,_RoleLv) when _RoleLv >= 242, _RoleLv =< 242 ->
		[{5,0,245749700}];
get_reward(2,_RoleLv) when _RoleLv >= 243, _RoleLv =< 243 ->
		[{5,0,247982200}];
get_reward(2,_RoleLv) when _RoleLv >= 244, _RoleLv =< 244 ->
		[{5,0,250227100}];
get_reward(2,_RoleLv) when _RoleLv >= 245, _RoleLv =< 245 ->
		[{5,0,252484500}];
get_reward(2,_RoleLv) when _RoleLv >= 246, _RoleLv =< 246 ->
		[{5,0,254754400}];
get_reward(2,_RoleLv) when _RoleLv >= 247, _RoleLv =< 247 ->
		[{5,0,257036900}];
get_reward(2,_RoleLv) when _RoleLv >= 248, _RoleLv =< 248 ->
		[{5,0,259331800}];
get_reward(2,_RoleLv) when _RoleLv >= 249, _RoleLv =< 249 ->
		[{5,0,261639300}];
get_reward(2,_RoleLv) when _RoleLv >= 250, _RoleLv =< 250 ->
		[{5,0,263959500}];
get_reward(2,_RoleLv) when _RoleLv >= 251, _RoleLv =< 251 ->
		[{5,0,266292200}];
get_reward(2,_RoleLv) when _RoleLv >= 252, _RoleLv =< 252 ->
		[{5,0,268637600}];
get_reward(2,_RoleLv) when _RoleLv >= 253, _RoleLv =< 253 ->
		[{5,0,270995600}];
get_reward(2,_RoleLv) when _RoleLv >= 254, _RoleLv =< 254 ->
		[{5,0,273366400}];
get_reward(2,_RoleLv) when _RoleLv >= 255, _RoleLv =< 255 ->
		[{5,0,275749800}];
get_reward(2,_RoleLv) when _RoleLv >= 256, _RoleLv =< 256 ->
		[{5,0,278146000}];
get_reward(2,_RoleLv) when _RoleLv >= 257, _RoleLv =< 257 ->
		[{5,0,280555000}];
get_reward(2,_RoleLv) when _RoleLv >= 258, _RoleLv =< 258 ->
		[{5,0,282976800}];
get_reward(2,_RoleLv) when _RoleLv >= 259, _RoleLv =< 259 ->
		[{5,0,285411400}];
get_reward(2,_RoleLv) when _RoleLv >= 260, _RoleLv =< 260 ->
		[{5,0,287858800}];
get_reward(2,_RoleLv) when _RoleLv >= 261, _RoleLv =< 261 ->
		[{5,0,290319200}];
get_reward(2,_RoleLv) when _RoleLv >= 262, _RoleLv =< 262 ->
		[{5,0,292792400}];
get_reward(2,_RoleLv) when _RoleLv >= 263, _RoleLv =< 263 ->
		[{5,0,295278500}];
get_reward(2,_RoleLv) when _RoleLv >= 264, _RoleLv =< 264 ->
		[{5,0,297777600}];
get_reward(2,_RoleLv) when _RoleLv >= 265, _RoleLv =< 265 ->
		[{5,0,300289700}];
get_reward(2,_RoleLv) when _RoleLv >= 266, _RoleLv =< 266 ->
		[{5,0,302814700}];
get_reward(2,_RoleLv) when _RoleLv >= 267, _RoleLv =< 267 ->
		[{5,0,305352800}];
get_reward(2,_RoleLv) when _RoleLv >= 268, _RoleLv =< 268 ->
		[{5,0,307904000}];
get_reward(2,_RoleLv) when _RoleLv >= 269, _RoleLv =< 269 ->
		[{5,0,310468200}];
get_reward(2,_RoleLv) when _RoleLv >= 270, _RoleLv =< 270 ->
		[{5,0,313045500}];
get_reward(2,_RoleLv) when _RoleLv >= 271, _RoleLv =< 271 ->
		[{5,0,315635900}];
get_reward(2,_RoleLv) when _RoleLv >= 272, _RoleLv =< 272 ->
		[{5,0,318239500}];
get_reward(2,_RoleLv) when _RoleLv >= 273, _RoleLv =< 273 ->
		[{5,0,320856300}];
get_reward(2,_RoleLv) when _RoleLv >= 274, _RoleLv =< 274 ->
		[{5,0,323486200}];
get_reward(2,_RoleLv) when _RoleLv >= 275, _RoleLv =< 275 ->
		[{5,0,326129400}];
get_reward(2,_RoleLv) when _RoleLv >= 276, _RoleLv =< 276 ->
		[{5,0,328785800}];
get_reward(2,_RoleLv) when _RoleLv >= 277, _RoleLv =< 277 ->
		[{5,0,331455500}];
get_reward(2,_RoleLv) when _RoleLv >= 278, _RoleLv =< 278 ->
		[{5,0,334138500}];
get_reward(2,_RoleLv) when _RoleLv >= 279, _RoleLv =< 279 ->
		[{5,0,336834900}];
get_reward(2,_RoleLv) when _RoleLv >= 280, _RoleLv =< 280 ->
		[{5,0,339544500}];
get_reward(2,_RoleLv) when _RoleLv >= 281, _RoleLv =< 281 ->
		[{5,0,342267600}];
get_reward(2,_RoleLv) when _RoleLv >= 282, _RoleLv =< 282 ->
		[{5,0,345004000}];
get_reward(2,_RoleLv) when _RoleLv >= 283, _RoleLv =< 283 ->
		[{5,0,347753900}];
get_reward(2,_RoleLv) when _RoleLv >= 284, _RoleLv =< 284 ->
		[{5,0,350517200}];
get_reward(2,_RoleLv) when _RoleLv >= 285, _RoleLv =< 285 ->
		[{5,0,353294000}];
get_reward(2,_RoleLv) when _RoleLv >= 286, _RoleLv =< 286 ->
		[{5,0,356084300}];
get_reward(2,_RoleLv) when _RoleLv >= 287, _RoleLv =< 287 ->
		[{5,0,358888100}];
get_reward(2,_RoleLv) when _RoleLv >= 288, _RoleLv =< 288 ->
		[{5,0,361705400}];
get_reward(2,_RoleLv) when _RoleLv >= 289, _RoleLv =< 289 ->
		[{5,0,364536300}];
get_reward(2,_RoleLv) when _RoleLv >= 290, _RoleLv =< 290 ->
		[{5,0,367380800}];
get_reward(2,_RoleLv) when _RoleLv >= 291, _RoleLv =< 291 ->
		[{5,0,370239000}];
get_reward(2,_RoleLv) when _RoleLv >= 292, _RoleLv =< 292 ->
		[{5,0,373110700}];
get_reward(2,_RoleLv) when _RoleLv >= 293, _RoleLv =< 293 ->
		[{5,0,375996200}];
get_reward(2,_RoleLv) when _RoleLv >= 294, _RoleLv =< 294 ->
		[{5,0,378895300}];
get_reward(2,_RoleLv) when _RoleLv >= 295, _RoleLv =< 295 ->
		[{5,0,381808100}];
get_reward(2,_RoleLv) when _RoleLv >= 296, _RoleLv =< 296 ->
		[{5,0,384734700}];
get_reward(2,_RoleLv) when _RoleLv >= 297, _RoleLv =< 297 ->
		[{5,0,387675100}];
get_reward(2,_RoleLv) when _RoleLv >= 298, _RoleLv =< 298 ->
		[{5,0,390629200}];
get_reward(2,_RoleLv) when _RoleLv >= 299, _RoleLv =< 299 ->
		[{5,0,393597200}];
get_reward(2,_RoleLv) when _RoleLv >= 300, _RoleLv =< 300 ->
		[{5,0,396578900}];
get_reward(2,_RoleLv) when _RoleLv >= 301, _RoleLv =< 301 ->
		[{5,0,399574600}];
get_reward(2,_RoleLv) when _RoleLv >= 302, _RoleLv =< 302 ->
		[{5,0,402584100}];
get_reward(2,_RoleLv) when _RoleLv >= 303, _RoleLv =< 303 ->
		[{5,0,405607600}];
get_reward(2,_RoleLv) when _RoleLv >= 304, _RoleLv =< 304 ->
		[{5,0,408644900}];
get_reward(2,_RoleLv) when _RoleLv >= 305, _RoleLv =< 305 ->
		[{5,0,411696300}];
get_reward(2,_RoleLv) when _RoleLv >= 306, _RoleLv =< 306 ->
		[{5,0,414761600}];
get_reward(2,_RoleLv) when _RoleLv >= 307, _RoleLv =< 307 ->
		[{5,0,417840900}];
get_reward(2,_RoleLv) when _RoleLv >= 308, _RoleLv =< 308 ->
		[{5,0,420934200}];
get_reward(2,_RoleLv) when _RoleLv >= 309, _RoleLv =< 309 ->
		[{5,0,424041600}];
get_reward(2,_RoleLv) when _RoleLv >= 310, _RoleLv =< 310 ->
		[{5,0,427163100}];
get_reward(2,_RoleLv) when _RoleLv >= 311, _RoleLv =< 311 ->
		[{5,0,430298700}];
get_reward(2,_RoleLv) when _RoleLv >= 312, _RoleLv =< 312 ->
		[{5,0,433448400}];
get_reward(2,_RoleLv) when _RoleLv >= 313, _RoleLv =< 313 ->
		[{5,0,436612200}];
get_reward(2,_RoleLv) when _RoleLv >= 314, _RoleLv =< 314 ->
		[{5,0,439790200}];
get_reward(2,_RoleLv) when _RoleLv >= 315, _RoleLv =< 315 ->
		[{5,0,442982400}];
get_reward(2,_RoleLv) when _RoleLv >= 316, _RoleLv =< 316 ->
		[{5,0,446188900}];
get_reward(2,_RoleLv) when _RoleLv >= 317, _RoleLv =< 317 ->
		[{5,0,449409500}];
get_reward(2,_RoleLv) when _RoleLv >= 318, _RoleLv =< 318 ->
		[{5,0,452644500}];
get_reward(2,_RoleLv) when _RoleLv >= 319, _RoleLv =< 319 ->
		[{5,0,455893700}];
get_reward(2,_RoleLv) when _RoleLv >= 320, _RoleLv =< 320 ->
		[{5,0,459157300}];
get_reward(2,_RoleLv) when _RoleLv >= 321, _RoleLv =< 321 ->
		[{5,0,462435100}];
get_reward(2,_RoleLv) when _RoleLv >= 322, _RoleLv =< 322 ->
		[{5,0,465727400}];
get_reward(2,_RoleLv) when _RoleLv >= 323, _RoleLv =< 323 ->
		[{5,0,469034000}];
get_reward(2,_RoleLv) when _RoleLv >= 324, _RoleLv =< 324 ->
		[{5,0,472355000}];
get_reward(2,_RoleLv) when _RoleLv >= 325, _RoleLv =< 325 ->
		[{5,0,475690500}];
get_reward(2,_RoleLv) when _RoleLv >= 326, _RoleLv =< 326 ->
		[{5,0,479040400}];
get_reward(2,_RoleLv) when _RoleLv >= 327, _RoleLv =< 327 ->
		[{5,0,482404800}];
get_reward(2,_RoleLv) when _RoleLv >= 328, _RoleLv =< 328 ->
		[{5,0,485783700}];
get_reward(2,_RoleLv) when _RoleLv >= 329, _RoleLv =< 329 ->
		[{5,0,489177200}];
get_reward(2,_RoleLv) when _RoleLv >= 330, _RoleLv =< 330 ->
		[{5,0,492585100}];
get_reward(2,_RoleLv) when _RoleLv >= 331, _RoleLv =< 331 ->
		[{5,0,496007700}];
get_reward(2,_RoleLv) when _RoleLv >= 332, _RoleLv =< 332 ->
		[{5,0,499444800}];
get_reward(2,_RoleLv) when _RoleLv >= 333, _RoleLv =< 333 ->
		[{5,0,502896600}];
get_reward(2,_RoleLv) when _RoleLv >= 334, _RoleLv =< 334 ->
		[{5,0,506363000}];
get_reward(2,_RoleLv) when _RoleLv >= 335, _RoleLv =< 335 ->
		[{5,0,509844000}];
get_reward(2,_RoleLv) when _RoleLv >= 336, _RoleLv =< 336 ->
		[{5,0,513339800}];
get_reward(2,_RoleLv) when _RoleLv >= 337, _RoleLv =< 337 ->
		[{5,0,516850300}];
get_reward(2,_RoleLv) when _RoleLv >= 338, _RoleLv =< 338 ->
		[{5,0,520375500}];
get_reward(2,_RoleLv) when _RoleLv >= 339, _RoleLv =< 339 ->
		[{5,0,523915400}];
get_reward(2,_RoleLv) when _RoleLv >= 340, _RoleLv =< 340 ->
		[{5,0,527470200}];
get_reward(2,_RoleLv) when _RoleLv >= 341, _RoleLv =< 341 ->
		[{5,0,531039700}];
get_reward(2,_RoleLv) when _RoleLv >= 342, _RoleLv =< 342 ->
		[{5,0,534624100}];
get_reward(2,_RoleLv) when _RoleLv >= 343, _RoleLv =< 343 ->
		[{5,0,538223300}];
get_reward(2,_RoleLv) when _RoleLv >= 344, _RoleLv =< 344 ->
		[{5,0,541837400}];
get_reward(2,_RoleLv) when _RoleLv >= 345, _RoleLv =< 345 ->
		[{5,0,545466400}];
get_reward(2,_RoleLv) when _RoleLv >= 346, _RoleLv =< 346 ->
		[{5,0,549110300}];
get_reward(2,_RoleLv) when _RoleLv >= 347, _RoleLv =< 347 ->
		[{5,0,552769100}];
get_reward(2,_RoleLv) when _RoleLv >= 348, _RoleLv =< 348 ->
		[{5,0,556442900}];
get_reward(2,_RoleLv) when _RoleLv >= 349, _RoleLv =< 349 ->
		[{5,0,560131700}];
get_reward(2,_RoleLv) when _RoleLv >= 350, _RoleLv =< 350 ->
		[{5,0,563835500}];
get_reward(2,_RoleLv) when _RoleLv >= 351, _RoleLv =< 351 ->
		[{5,0,567554400}];
get_reward(2,_RoleLv) when _RoleLv >= 352, _RoleLv =< 352 ->
		[{5,0,571288300}];
get_reward(2,_RoleLv) when _RoleLv >= 353, _RoleLv =< 353 ->
		[{5,0,575037300}];
get_reward(2,_RoleLv) when _RoleLv >= 354, _RoleLv =< 354 ->
		[{5,0,578801300}];
get_reward(2,_RoleLv) when _RoleLv >= 355, _RoleLv =< 355 ->
		[{5,0,582580500}];
get_reward(2,_RoleLv) when _RoleLv >= 356, _RoleLv =< 356 ->
		[{5,0,586374900}];
get_reward(2,_RoleLv) when _RoleLv >= 357, _RoleLv =< 357 ->
		[{5,0,590184400}];
get_reward(2,_RoleLv) when _RoleLv >= 358, _RoleLv =< 358 ->
		[{5,0,594009100}];
get_reward(2,_RoleLv) when _RoleLv >= 359, _RoleLv =< 359 ->
		[{5,0,597849100}];
get_reward(2,_RoleLv) when _RoleLv >= 360, _RoleLv =< 360 ->
		[{5,0,601704200}];
get_reward(2,_RoleLv) when _RoleLv >= 361, _RoleLv =< 361 ->
		[{5,0,605574700}];
get_reward(2,_RoleLv) when _RoleLv >= 362, _RoleLv =< 362 ->
		[{5,0,609460400}];
get_reward(2,_RoleLv) when _RoleLv >= 363, _RoleLv =< 363 ->
		[{5,0,613361400}];
get_reward(2,_RoleLv) when _RoleLv >= 364, _RoleLv =< 364 ->
		[{5,0,617277700}];
get_reward(2,_RoleLv) when _RoleLv >= 365, _RoleLv =< 365 ->
		[{5,0,621209400}];
get_reward(2,_RoleLv) when _RoleLv >= 366, _RoleLv =< 366 ->
		[{5,0,625156500}];
get_reward(2,_RoleLv) when _RoleLv >= 367, _RoleLv =< 367 ->
		[{5,0,629118900}];
get_reward(2,_RoleLv) when _RoleLv >= 368, _RoleLv =< 368 ->
		[{5,0,633096800}];
get_reward(2,_RoleLv) when _RoleLv >= 369, _RoleLv =< 369 ->
		[{5,0,637090100}];
get_reward(2,_RoleLv) when _RoleLv >= 370, _RoleLv =< 370 ->
		[{5,0,641098900}];
get_reward(2,_RoleLv) when _RoleLv >= 371, _RoleLv =< 371 ->
		[{5,0,645123200}];
get_reward(2,_RoleLv) when _RoleLv >= 372, _RoleLv =< 372 ->
		[{5,0,649163000}];
get_reward(2,_RoleLv) when _RoleLv >= 373, _RoleLv =< 373 ->
		[{5,0,653218300}];
get_reward(2,_RoleLv) when _RoleLv >= 374, _RoleLv =< 374 ->
		[{5,0,657289100}];
get_reward(2,_RoleLv) when _RoleLv >= 375, _RoleLv =< 375 ->
		[{5,0,661375600}];
get_reward(2,_RoleLv) when _RoleLv >= 376, _RoleLv =< 376 ->
		[{5,0,665477600}];
get_reward(2,_RoleLv) when _RoleLv >= 377, _RoleLv =< 377 ->
		[{5,0,669595300}];
get_reward(2,_RoleLv) when _RoleLv >= 378, _RoleLv =< 378 ->
		[{5,0,673728600}];
get_reward(2,_RoleLv) when _RoleLv >= 379, _RoleLv =< 379 ->
		[{5,0,677877500}];
get_reward(2,_RoleLv) when _RoleLv >= 380, _RoleLv =< 380 ->
		[{5,0,682042200}];
get_reward(2,_RoleLv) when _RoleLv >= 381, _RoleLv =< 381 ->
		[{5,0,686222500}];
get_reward(2,_RoleLv) when _RoleLv >= 382, _RoleLv =< 382 ->
		[{5,0,690418600}];
get_reward(2,_RoleLv) when _RoleLv >= 383, _RoleLv =< 383 ->
		[{5,0,694630400}];
get_reward(2,_RoleLv) when _RoleLv >= 384, _RoleLv =< 384 ->
		[{5,0,698858000}];
get_reward(2,_RoleLv) when _RoleLv >= 385, _RoleLv =< 385 ->
		[{5,0,703101400}];
get_reward(2,_RoleLv) when _RoleLv >= 386, _RoleLv =< 386 ->
		[{5,0,707360700}];
get_reward(2,_RoleLv) when _RoleLv >= 387, _RoleLv =< 387 ->
		[{5,0,711635700}];
get_reward(2,_RoleLv) when _RoleLv >= 388, _RoleLv =< 388 ->
		[{5,0,715926700}];
get_reward(2,_RoleLv) when _RoleLv >= 389, _RoleLv =< 389 ->
		[{5,0,720233500}];
get_reward(2,_RoleLv) when _RoleLv >= 390, _RoleLv =< 390 ->
		[{5,0,724556200}];
get_reward(2,_RoleLv) when _RoleLv >= 391, _RoleLv =< 391 ->
		[{5,0,728894800}];
get_reward(2,_RoleLv) when _RoleLv >= 392, _RoleLv =< 392 ->
		[{5,0,733249400}];
get_reward(2,_RoleLv) when _RoleLv >= 393, _RoleLv =< 393 ->
		[{5,0,737620000}];
get_reward(2,_RoleLv) when _RoleLv >= 394, _RoleLv =< 394 ->
		[{5,0,742006600}];
get_reward(2,_RoleLv) when _RoleLv >= 395, _RoleLv =< 395 ->
		[{5,0,746409200}];
get_reward(2,_RoleLv) when _RoleLv >= 396, _RoleLv =< 396 ->
		[{5,0,750827800}];
get_reward(2,_RoleLv) when _RoleLv >= 397, _RoleLv =< 397 ->
		[{5,0,755262500}];
get_reward(2,_RoleLv) when _RoleLv >= 398, _RoleLv =< 398 ->
		[{5,0,759713200}];
get_reward(2,_RoleLv) when _RoleLv >= 399, _RoleLv =< 399 ->
		[{5,0,764180100}];
get_reward(2,_RoleLv) when _RoleLv >= 400, _RoleLv =< 400 ->
		[{5,0,768663100}];
get_reward(2,_RoleLv) when _RoleLv >= 401, _RoleLv =< 401 ->
		[{5,0,773162200}];
get_reward(2,_RoleLv) when _RoleLv >= 402, _RoleLv =< 402 ->
		[{5,0,777677500}];
get_reward(2,_RoleLv) when _RoleLv >= 403, _RoleLv =< 403 ->
		[{5,0,782209100}];
get_reward(2,_RoleLv) when _RoleLv >= 404, _RoleLv =< 404 ->
		[{5,0,786756800}];
get_reward(2,_RoleLv) when _RoleLv >= 405, _RoleLv =< 405 ->
		[{5,0,791320700}];
get_reward(2,_RoleLv) when _RoleLv >= 406, _RoleLv =< 406 ->
		[{5,0,795900900}];
get_reward(2,_RoleLv) when _RoleLv >= 407, _RoleLv =< 407 ->
		[{5,0,800497400}];
get_reward(2,_RoleLv) when _RoleLv >= 408, _RoleLv =< 408 ->
		[{5,0,805110200}];
get_reward(2,_RoleLv) when _RoleLv >= 409, _RoleLv =< 409 ->
		[{5,0,809739300}];
get_reward(2,_RoleLv) when _RoleLv >= 410, _RoleLv =< 410 ->
		[{5,0,814384700}];
get_reward(2,_RoleLv) when _RoleLv >= 411, _RoleLv =< 411 ->
		[{5,0,819046600}];
get_reward(2,_RoleLv) when _RoleLv >= 412, _RoleLv =< 412 ->
		[{5,0,823724800}];
get_reward(2,_RoleLv) when _RoleLv >= 413, _RoleLv =< 413 ->
		[{5,0,828419400}];
get_reward(2,_RoleLv) when _RoleLv >= 414, _RoleLv =< 414 ->
		[{5,0,833130400}];
get_reward(2,_RoleLv) when _RoleLv >= 415, _RoleLv =< 415 ->
		[{5,0,837857900}];
get_reward(2,_RoleLv) when _RoleLv >= 416, _RoleLv =< 416 ->
		[{5,0,842601800}];
get_reward(2,_RoleLv) when _RoleLv >= 417, _RoleLv =< 417 ->
		[{5,0,847362300}];
get_reward(2,_RoleLv) when _RoleLv >= 418, _RoleLv =< 418 ->
		[{5,0,852139300}];
get_reward(2,_RoleLv) when _RoleLv >= 419, _RoleLv =< 419 ->
		[{5,0,856932800}];
get_reward(2,_RoleLv) when _RoleLv >= 420, _RoleLv =< 420 ->
		[{5,0,861742800}];
get_reward(2,_RoleLv) when _RoleLv >= 421, _RoleLv =< 421 ->
		[{5,0,866569500}];
get_reward(2,_RoleLv) when _RoleLv >= 422, _RoleLv =< 422 ->
		[{5,0,871412700}];
get_reward(2,_RoleLv) when _RoleLv >= 423, _RoleLv =< 423 ->
		[{5,0,876272600}];
get_reward(2,_RoleLv) when _RoleLv >= 424, _RoleLv =< 424 ->
		[{5,0,881149100}];
get_reward(2,_RoleLv) when _RoleLv >= 425, _RoleLv =< 425 ->
		[{5,0,886042200}];
get_reward(2,_RoleLv) when _RoleLv >= 426, _RoleLv =< 426 ->
		[{5,0,890952100}];
get_reward(2,_RoleLv) when _RoleLv >= 427, _RoleLv =< 427 ->
		[{5,0,895878700}];
get_reward(2,_RoleLv) when _RoleLv >= 428, _RoleLv =< 428 ->
		[{5,0,900822000}];
get_reward(2,_RoleLv) when _RoleLv >= 429, _RoleLv =< 429 ->
		[{5,0,905782000}];
get_reward(2,_RoleLv) when _RoleLv >= 430, _RoleLv =< 430 ->
		[{5,0,910758800}];
get_reward(2,_RoleLv) when _RoleLv >= 431, _RoleLv =< 431 ->
		[{5,0,915752400}];
get_reward(2,_RoleLv) when _RoleLv >= 432, _RoleLv =< 432 ->
		[{5,0,920762800}];
get_reward(2,_RoleLv) when _RoleLv >= 433, _RoleLv =< 433 ->
		[{5,0,925790100}];
get_reward(2,_RoleLv) when _RoleLv >= 434, _RoleLv =< 434 ->
		[{5,0,930834200}];
get_reward(2,_RoleLv) when _RoleLv >= 435, _RoleLv =< 435 ->
		[{5,0,935895200}];
get_reward(2,_RoleLv) when _RoleLv >= 436, _RoleLv =< 436 ->
		[{5,0,940973100}];
get_reward(2,_RoleLv) when _RoleLv >= 437, _RoleLv =< 437 ->
		[{5,0,946067900}];
get_reward(2,_RoleLv) when _RoleLv >= 438, _RoleLv =< 438 ->
		[{5,0,951179600}];
get_reward(2,_RoleLv) when _RoleLv >= 439, _RoleLv =< 439 ->
		[{5,0,956308300}];
get_reward(2,_RoleLv) when _RoleLv >= 440, _RoleLv =< 440 ->
		[{5,0,961454000}];
get_reward(2,_RoleLv) when _RoleLv >= 441, _RoleLv =< 441 ->
		[{5,0,966616700}];
get_reward(2,_RoleLv) when _RoleLv >= 442, _RoleLv =< 442 ->
		[{5,0,971796400}];
get_reward(2,_RoleLv) when _RoleLv >= 443, _RoleLv =< 443 ->
		[{5,0,976993200}];
get_reward(2,_RoleLv) when _RoleLv >= 444, _RoleLv =< 444 ->
		[{5,0,982207000}];
get_reward(2,_RoleLv) when _RoleLv >= 445, _RoleLv =< 445 ->
		[{5,0,987437900}];
get_reward(2,_RoleLv) when _RoleLv >= 446, _RoleLv =< 446 ->
		[{5,0,992686000}];
get_reward(2,_RoleLv) when _RoleLv >= 447, _RoleLv =< 447 ->
		[{5,0,997951100}];
get_reward(2,_RoleLv) when _RoleLv >= 448, _RoleLv =< 448 ->
		[{5,0,1003233400}];
get_reward(2,_RoleLv) when _RoleLv >= 449, _RoleLv =< 449 ->
		[{5,0,1008532900}];
get_reward(2,_RoleLv) when _RoleLv >= 450, _RoleLv =< 450 ->
		[{5,0,1013849600}];
get_reward(2,_RoleLv) when _RoleLv >= 451, _RoleLv =< 451 ->
		[{5,0,1019183400}];
get_reward(2,_RoleLv) when _RoleLv >= 452, _RoleLv =< 452 ->
		[{5,0,1024534600}];
get_reward(2,_RoleLv) when _RoleLv >= 453, _RoleLv =< 453 ->
		[{5,0,1029902900}];
get_reward(2,_RoleLv) when _RoleLv >= 454, _RoleLv =< 454 ->
		[{5,0,1035288600}];
get_reward(2,_RoleLv) when _RoleLv >= 455, _RoleLv =< 455 ->
		[{5,0,1040691500}];
get_reward(2,_RoleLv) when _RoleLv >= 456, _RoleLv =< 456 ->
		[{5,0,1046111800}];
get_reward(2,_RoleLv) when _RoleLv >= 457, _RoleLv =< 457 ->
		[{5,0,1051549400}];
get_reward(2,_RoleLv) when _RoleLv >= 458, _RoleLv =< 458 ->
		[{5,0,1057004300}];
get_reward(2,_RoleLv) when _RoleLv >= 459, _RoleLv =< 459 ->
		[{5,0,1062476700}];
get_reward(2,_RoleLv) when _RoleLv >= 460, _RoleLv =< 460 ->
		[{5,0,1067966400}];
get_reward(2,_RoleLv) when _RoleLv >= 461, _RoleLv =< 461 ->
		[{5,0,1073473500}];
get_reward(2,_RoleLv) when _RoleLv >= 462, _RoleLv =< 462 ->
		[{5,0,1078998100}];
get_reward(2,_RoleLv) when _RoleLv >= 463, _RoleLv =< 463 ->
		[{5,0,1084540200}];
get_reward(2,_RoleLv) when _RoleLv >= 464, _RoleLv =< 464 ->
		[{5,0,1090099700}];
get_reward(2,_RoleLv) when _RoleLv >= 465, _RoleLv =< 465 ->
		[{5,0,1095676800}];
get_reward(2,_RoleLv) when _RoleLv >= 466, _RoleLv =< 466 ->
		[{5,0,1101271300}];
get_reward(2,_RoleLv) when _RoleLv >= 467, _RoleLv =< 467 ->
		[{5,0,1106883500}];
get_reward(2,_RoleLv) when _RoleLv >= 468, _RoleLv =< 468 ->
		[{5,0,1112513100}];
get_reward(2,_RoleLv) when _RoleLv >= 469, _RoleLv =< 469 ->
		[{5,0,1118160400}];
get_reward(2,_RoleLv) when _RoleLv >= 470, _RoleLv =< 470 ->
		[{5,0,1123825300}];
get_reward(2,_RoleLv) when _RoleLv >= 471, _RoleLv =< 471 ->
		[{5,0,1129507800}];
get_reward(2,_RoleLv) when _RoleLv >= 472, _RoleLv =< 472 ->
		[{5,0,1135207900}];
get_reward(2,_RoleLv) when _RoleLv >= 473, _RoleLv =< 473 ->
		[{5,0,1140925700}];
get_reward(2,_RoleLv) when _RoleLv >= 474, _RoleLv =< 474 ->
		[{5,0,1146661200}];
get_reward(2,_RoleLv) when _RoleLv >= 475, _RoleLv =< 475 ->
		[{5,0,1152414400}];
get_reward(2,_RoleLv) when _RoleLv >= 476, _RoleLv =< 476 ->
		[{5,0,1158185400}];
get_reward(2,_RoleLv) when _RoleLv >= 477, _RoleLv =< 477 ->
		[{5,0,1163974100}];
get_reward(2,_RoleLv) when _RoleLv >= 478, _RoleLv =< 478 ->
		[{5,0,1169780500}];
get_reward(2,_RoleLv) when _RoleLv >= 479, _RoleLv =< 479 ->
		[{5,0,1175604800}];
get_reward(2,_RoleLv) when _RoleLv >= 480, _RoleLv =< 480 ->
		[{5,0,1181446900}];
get_reward(2,_RoleLv) when _RoleLv >= 481, _RoleLv =< 481 ->
		[{5,0,1187306700}];
get_reward(2,_RoleLv) when _RoleLv >= 482, _RoleLv =< 482 ->
		[{5,0,1193184500}];
get_reward(2,_RoleLv) when _RoleLv >= 483, _RoleLv =< 483 ->
		[{5,0,1199080100}];
get_reward(2,_RoleLv) when _RoleLv >= 484, _RoleLv =< 484 ->
		[{5,0,1204993600}];
get_reward(2,_RoleLv) when _RoleLv >= 485, _RoleLv =< 485 ->
		[{5,0,1210925000}];
get_reward(2,_RoleLv) when _RoleLv >= 486, _RoleLv =< 486 ->
		[{5,0,1216874400}];
get_reward(2,_RoleLv) when _RoleLv >= 487, _RoleLv =< 487 ->
		[{5,0,1222841700}];
get_reward(2,_RoleLv) when _RoleLv >= 488, _RoleLv =< 488 ->
		[{5,0,1228827000}];
get_reward(2,_RoleLv) when _RoleLv >= 489, _RoleLv =< 489 ->
		[{5,0,1234830300}];
get_reward(2,_RoleLv) when _RoleLv >= 490, _RoleLv =< 490 ->
		[{5,0,1240851600}];
get_reward(2,_RoleLv) when _RoleLv >= 491, _RoleLv =< 491 ->
		[{5,0,1246890900}];
get_reward(2,_RoleLv) when _RoleLv >= 492, _RoleLv =< 492 ->
		[{5,0,1252948300}];
get_reward(2,_RoleLv) when _RoleLv >= 493, _RoleLv =< 493 ->
		[{5,0,1259023700}];
get_reward(2,_RoleLv) when _RoleLv >= 494, _RoleLv =< 494 ->
		[{5,0,1265117300}];
get_reward(2,_RoleLv) when _RoleLv >= 495, _RoleLv =< 495 ->
		[{5,0,1271229000}];
get_reward(2,_RoleLv) when _RoleLv >= 496, _RoleLv =< 496 ->
		[{5,0,1277358800}];
get_reward(2,_RoleLv) when _RoleLv >= 497, _RoleLv =< 497 ->
		[{5,0,1283506700}];
get_reward(2,_RoleLv) when _RoleLv >= 498, _RoleLv =< 498 ->
		[{5,0,1289672800}];
get_reward(2,_RoleLv) when _RoleLv >= 499, _RoleLv =< 499 ->
		[{5,0,1295857200}];
get_reward(2,_RoleLv) when _RoleLv >= 500, _RoleLv =< 500 ->
		[{5,0,1302059700}];
get_reward(2,_RoleLv) when _RoleLv >= 501, _RoleLv =< 501 ->
		[{5,0,1308280500}];
get_reward(2,_RoleLv) when _RoleLv >= 502, _RoleLv =< 502 ->
		[{5,0,1314519500}];
get_reward(2,_RoleLv) when _RoleLv >= 503, _RoleLv =< 503 ->
		[{5,0,1320776900}];
get_reward(2,_RoleLv) when _RoleLv >= 504, _RoleLv =< 504 ->
		[{5,0,1327052500}];
get_reward(2,_RoleLv) when _RoleLv >= 505, _RoleLv =< 505 ->
		[{5,0,1333346400}];
get_reward(2,_RoleLv) when _RoleLv >= 506, _RoleLv =< 506 ->
		[{5,0,1339658700}];
get_reward(2,_RoleLv) when _RoleLv >= 507, _RoleLv =< 507 ->
		[{5,0,1345989300}];
get_reward(2,_RoleLv) when _RoleLv >= 508, _RoleLv =< 508 ->
		[{5,0,1352338300}];
get_reward(2,_RoleLv) when _RoleLv >= 509, _RoleLv =< 509 ->
		[{5,0,1358705700}];
get_reward(2,_RoleLv) when _RoleLv >= 510, _RoleLv =< 510 ->
		[{5,0,1365091500}];
get_reward(2,_RoleLv) when _RoleLv >= 511, _RoleLv =< 511 ->
		[{5,0,1371495700}];
get_reward(2,_RoleLv) when _RoleLv >= 512, _RoleLv =< 512 ->
		[{5,0,1377918400}];
get_reward(2,_RoleLv) when _RoleLv >= 513, _RoleLv =< 513 ->
		[{5,0,1384359600}];
get_reward(2,_RoleLv) when _RoleLv >= 514, _RoleLv =< 514 ->
		[{5,0,1390819300}];
get_reward(2,_RoleLv) when _RoleLv >= 515, _RoleLv =< 515 ->
		[{5,0,1397297500}];
get_reward(2,_RoleLv) when _RoleLv >= 516, _RoleLv =< 516 ->
		[{5,0,1403794200}];
get_reward(2,_RoleLv) when _RoleLv >= 517, _RoleLv =< 517 ->
		[{5,0,1410309500}];
get_reward(2,_RoleLv) when _RoleLv >= 518, _RoleLv =< 518 ->
		[{5,0,1416843300}];
get_reward(2,_RoleLv) when _RoleLv >= 519, _RoleLv =< 519 ->
		[{5,0,1423395800}];
get_reward(2,_RoleLv) when _RoleLv >= 520, _RoleLv =< 520 ->
		[{5,0,1429966800}];
get_reward(2,_RoleLv) when _RoleLv >= 521, _RoleLv =< 521 ->
		[{5,0,2707723800}];
get_reward(2,_RoleLv) when _RoleLv >= 522, _RoleLv =< 522 ->
		[{5,0,2720659900}];
get_reward(2,_RoleLv) when _RoleLv >= 523, _RoleLv =< 523 ->
		[{5,0,2733634900}];
get_reward(2,_RoleLv) when _RoleLv >= 524, _RoleLv =< 524 ->
		[{5,0,2746648700}];
get_reward(2,_RoleLv) when _RoleLv >= 525, _RoleLv =< 525 ->
		[{5,0,2759701500}];
get_reward(2,_RoleLv) when _RoleLv >= 526, _RoleLv =< 526 ->
		[{5,0,2772793300}];
get_reward(2,_RoleLv) when _RoleLv >= 527, _RoleLv =< 527 ->
		[{5,0,2785924100}];
get_reward(2,_RoleLv) when _RoleLv >= 528, _RoleLv =< 528 ->
		[{5,0,2799094000}];
get_reward(2,_RoleLv) when _RoleLv >= 529, _RoleLv =< 529 ->
		[{5,0,2812303000}];
get_reward(2,_RoleLv) when _RoleLv >= 530, _RoleLv =< 530 ->
		[{5,0,2825551200}];
get_reward(2,_RoleLv) when _RoleLv >= 531, _RoleLv =< 531 ->
		[{5,0,2838838600}];
get_reward(2,_RoleLv) when _RoleLv >= 532, _RoleLv =< 532 ->
		[{5,0,2852165300}];
get_reward(2,_RoleLv) when _RoleLv >= 533, _RoleLv =< 533 ->
		[{5,0,2865531300}];
get_reward(2,_RoleLv) when _RoleLv >= 534, _RoleLv =< 534 ->
		[{5,0,2878936700}];
get_reward(2,_RoleLv) when _RoleLv >= 535, _RoleLv =< 535 ->
		[{5,0,2892381600}];
get_reward(2,_RoleLv) when _RoleLv >= 536, _RoleLv =< 536 ->
		[{5,0,2905865800}];
get_reward(2,_RoleLv) when _RoleLv >= 537, _RoleLv =< 537 ->
		[{5,0,2919389600}];
get_reward(2,_RoleLv) when _RoleLv >= 538, _RoleLv =< 538 ->
		[{5,0,2932953000}];
get_reward(2,_RoleLv) when _RoleLv >= 539, _RoleLv =< 539 ->
		[{5,0,2946555900}];
get_reward(2,_RoleLv) when _RoleLv >= 540, _RoleLv =< 540 ->
		[{5,0,2960198500}];
get_reward(2,_RoleLv) when _RoleLv >= 541, _RoleLv =< 541 ->
		[{5,0,2973880800}];
get_reward(2,_RoleLv) when _RoleLv >= 542, _RoleLv =< 542 ->
		[{5,0,2987602900}];
get_reward(2,_RoleLv) when _RoleLv >= 543, _RoleLv =< 543 ->
		[{5,0,3001364800}];
get_reward(2,_RoleLv) when _RoleLv >= 544, _RoleLv =< 544 ->
		[{5,0,3015166500}];
get_reward(2,_RoleLv) when _RoleLv >= 545, _RoleLv =< 545 ->
		[{5,0,3029008100}];
get_reward(2,_RoleLv) when _RoleLv >= 546, _RoleLv =< 546 ->
		[{5,0,3042889600}];
get_reward(2,_RoleLv) when _RoleLv >= 547, _RoleLv =< 547 ->
		[{5,0,3056811100}];
get_reward(2,_RoleLv) when _RoleLv >= 548, _RoleLv =< 548 ->
		[{5,0,3070772700}];
get_reward(2,_RoleLv) when _RoleLv >= 549, _RoleLv =< 549 ->
		[{5,0,3084774400}];
get_reward(2,_RoleLv) when _RoleLv >= 550, _RoleLv =< 550 ->
		[{5,0,3098816100}];
get_reward(2,_RoleLv) when _RoleLv >= 551, _RoleLv =< 551 ->
		[{5,0,3112898100}];
get_reward(2,_RoleLv) when _RoleLv >= 552, _RoleLv =< 552 ->
		[{5,0,3127020300}];
get_reward(2,_RoleLv) when _RoleLv >= 553, _RoleLv =< 553 ->
		[{5,0,3141182700}];
get_reward(2,_RoleLv) when _RoleLv >= 554, _RoleLv =< 554 ->
		[{5,0,3155385500}];
get_reward(2,_RoleLv) when _RoleLv >= 555, _RoleLv =< 555 ->
		[{5,0,3169628600}];
get_reward(2,_RoleLv) when _RoleLv >= 556, _RoleLv =< 556 ->
		[{5,0,3183912100}];
get_reward(2,_RoleLv) when _RoleLv >= 557, _RoleLv =< 557 ->
		[{5,0,3198236100}];
get_reward(2,_RoleLv) when _RoleLv >= 558, _RoleLv =< 558 ->
		[{5,0,3212600600}];
get_reward(2,_RoleLv) when _RoleLv >= 559, _RoleLv =< 559 ->
		[{5,0,3227005700}];
get_reward(2,_RoleLv) when _RoleLv >= 560, _RoleLv =< 560 ->
		[{5,0,3241451400}];
get_reward(2,_RoleLv) when _RoleLv >= 561, _RoleLv =< 561 ->
		[{5,0,3255937700}];
get_reward(2,_RoleLv) when _RoleLv >= 562, _RoleLv =< 562 ->
		[{5,0,3270464700}];
get_reward(2,_RoleLv) when _RoleLv >= 563, _RoleLv =< 563 ->
		[{5,0,3285032500}];
get_reward(2,_RoleLv) when _RoleLv >= 564, _RoleLv =< 564 ->
		[{5,0,3299641000}];
get_reward(2,_RoleLv) when _RoleLv >= 565, _RoleLv =< 565 ->
		[{5,0,3314290400}];
get_reward(2,_RoleLv) when _RoleLv >= 566, _RoleLv =< 566 ->
		[{5,0,3328980600}];
get_reward(2,_RoleLv) when _RoleLv >= 567, _RoleLv =< 567 ->
		[{5,0,3343711800}];
get_reward(2,_RoleLv) when _RoleLv >= 568, _RoleLv =< 568 ->
		[{5,0,3358484000}];
get_reward(2,_RoleLv) when _RoleLv >= 569, _RoleLv =< 569 ->
		[{5,0,3373297200}];
get_reward(2,_RoleLv) when _RoleLv >= 570, _RoleLv =< 570 ->
		[{5,0,3388151400}];
get_reward(2,_RoleLv) when _RoleLv >= 571, _RoleLv =< 571 ->
		[{5,0,4691880700}];
get_reward(2,_RoleLv) when _RoleLv >= 572, _RoleLv =< 572 ->
		[{5,0,4712856300}];
get_reward(2,_RoleLv) when _RoleLv >= 573, _RoleLv =< 573 ->
		[{5,0,4733891600}];
get_reward(2,_RoleLv) when _RoleLv >= 574, _RoleLv =< 574 ->
		[{5,0,4754986500}];
get_reward(2,_RoleLv) when _RoleLv >= 575, _RoleLv =< 575 ->
		[{5,0,4776141100}];
get_reward(2,_RoleLv) when _RoleLv >= 576, _RoleLv =< 576 ->
		[{5,0,4797355500}];
get_reward(2,_RoleLv) when _RoleLv >= 577, _RoleLv =< 577 ->
		[{5,0,4818629800}];
get_reward(2,_RoleLv) when _RoleLv >= 578, _RoleLv =< 578 ->
		[{5,0,4839964000}];
get_reward(2,_RoleLv) when _RoleLv >= 579, _RoleLv =< 579 ->
		[{5,0,4861358200}];
get_reward(2,_RoleLv) when _RoleLv >= 580, _RoleLv =< 580 ->
		[{5,0,4882812500}];
get_reward(2,_RoleLv) when _RoleLv >= 581, _RoleLv =< 581 ->
		[{5,0,4904327000}];
get_reward(2,_RoleLv) when _RoleLv >= 582, _RoleLv =< 582 ->
		[{5,0,4925901700}];
get_reward(2,_RoleLv) when _RoleLv >= 583, _RoleLv =< 583 ->
		[{5,0,4947536700}];
get_reward(2,_RoleLv) when _RoleLv >= 584, _RoleLv =< 584 ->
		[{5,0,4969232000}];
get_reward(2,_RoleLv) when _RoleLv >= 585, _RoleLv =< 585 ->
		[{5,0,4990987800}];
get_reward(2,_RoleLv) when _RoleLv >= 586, _RoleLv =< 586 ->
		[{5,0,5012804200}];
get_reward(2,_RoleLv) when _RoleLv >= 587, _RoleLv =< 587 ->
		[{5,0,5034681100}];
get_reward(2,_RoleLv) when _RoleLv >= 588, _RoleLv =< 588 ->
		[{5,0,5056618700}];
get_reward(2,_RoleLv) when _RoleLv >= 589, _RoleLv =< 589 ->
		[{5,0,5078617000}];
get_reward(2,_RoleLv) when _RoleLv >= 590, _RoleLv =< 590 ->
		[{5,0,5100676100}];
get_reward(2,_RoleLv) when _RoleLv >= 591, _RoleLv =< 591 ->
		[{5,0,5122796100}];
get_reward(2,_RoleLv) when _RoleLv >= 592, _RoleLv =< 592 ->
		[{5,0,5144977000}];
get_reward(2,_RoleLv) when _RoleLv >= 593, _RoleLv =< 593 ->
		[{5,0,5167219000}];
get_reward(2,_RoleLv) when _RoleLv >= 594, _RoleLv =< 594 ->
		[{5,0,5189522000}];
get_reward(2,_RoleLv) when _RoleLv >= 595, _RoleLv =< 595 ->
		[{5,0,5211886200}];
get_reward(2,_RoleLv) when _RoleLv >= 596, _RoleLv =< 596 ->
		[{5,0,5234311700}];
get_reward(2,_RoleLv) when _RoleLv >= 597, _RoleLv =< 597 ->
		[{5,0,5256798500}];
get_reward(2,_RoleLv) when _RoleLv >= 598, _RoleLv =< 598 ->
		[{5,0,5279346600}];
get_reward(2,_RoleLv) when _RoleLv >= 599, _RoleLv =< 599 ->
		[{5,0,5301956200}];
get_reward(2,_RoleLv) when _RoleLv >= 600, _RoleLv =< 600 ->
		[{5,0,5324627300}];
get_reward(2,_RoleLv) when _RoleLv >= 601, _RoleLv =< 601 ->
		[{5,0,5347360000}];
get_reward(2,_RoleLv) when _RoleLv >= 602, _RoleLv =< 602 ->
		[{5,0,5370154400}];
get_reward(2,_RoleLv) when _RoleLv >= 603, _RoleLv =< 603 ->
		[{5,0,5393010500}];
get_reward(2,_RoleLv) when _RoleLv >= 604, _RoleLv =< 604 ->
		[{5,0,5415928400}];
get_reward(2,_RoleLv) when _RoleLv >= 605, _RoleLv =< 605 ->
		[{5,0,5438908200}];
get_reward(2,_RoleLv) when _RoleLv >= 606, _RoleLv =< 606 ->
		[{5,0,5461950000}];
get_reward(2,_RoleLv) when _RoleLv >= 607, _RoleLv =< 607 ->
		[{5,0,5485053800}];
get_reward(2,_RoleLv) when _RoleLv >= 608, _RoleLv =< 608 ->
		[{5,0,5508219600}];
get_reward(2,_RoleLv) when _RoleLv >= 609, _RoleLv =< 609 ->
		[{5,0,5531447700}];
get_reward(2,_RoleLv) when _RoleLv >= 610, _RoleLv =< 610 ->
		[{5,0,5554737900}];
get_reward(2,_RoleLv) when _RoleLv >= 611, _RoleLv =< 611 ->
		[{5,0,5578090500}];
get_reward(2,_RoleLv) when _RoleLv >= 612, _RoleLv =< 612 ->
		[{5,0,5601505500}];
get_reward(2,_RoleLv) when _RoleLv >= 613, _RoleLv =< 613 ->
		[{5,0,5624982900}];
get_reward(2,_RoleLv) when _RoleLv >= 614, _RoleLv =< 614 ->
		[{5,0,5648522900}];
get_reward(2,_RoleLv) when _RoleLv >= 615, _RoleLv =< 615 ->
		[{5,0,5672125400}];
get_reward(2,_RoleLv) when _RoleLv >= 616, _RoleLv =< 616 ->
		[{5,0,5695790600}];
get_reward(2,_RoleLv) when _RoleLv >= 617, _RoleLv =< 617 ->
		[{5,0,5719518500}];
get_reward(2,_RoleLv) when _RoleLv >= 618, _RoleLv =< 618 ->
		[{5,0,5743309300}];
get_reward(2,_RoleLv) when _RoleLv >= 619, _RoleLv =< 619 ->
		[{5,0,5767162900}];
get_reward(2,_RoleLv) when _RoleLv >= 620, _RoleLv =< 620 ->
		[{5,0,5791079500}];
get_reward(2,_RoleLv) when _RoleLv >= 621, _RoleLv =< 621 ->
		[{5,0,8048738900}];
get_reward(2,_RoleLv) when _RoleLv >= 622, _RoleLv =< 622 ->
		[{5,0,8082623200}];
get_reward(2,_RoleLv) when _RoleLv >= 623, _RoleLv =< 623 ->
		[{5,0,8116599100}];
get_reward(2,_RoleLv) when _RoleLv >= 624, _RoleLv =< 624 ->
		[{5,0,8150666600}];
get_reward(2,_RoleLv) when _RoleLv >= 625, _RoleLv =< 625 ->
		[{5,0,8184825900}];
get_reward(2,_RoleLv) when _RoleLv >= 626, _RoleLv =< 626 ->
		[{5,0,8219077100}];
get_reward(2,_RoleLv) when _RoleLv >= 627, _RoleLv =< 627 ->
		[{5,0,8253420400}];
get_reward(2,_RoleLv) when _RoleLv >= 628, _RoleLv =< 628 ->
		[{5,0,8287855700}];
get_reward(2,_RoleLv) when _RoleLv >= 629, _RoleLv =< 629 ->
		[{5,0,8322383200}];
get_reward(2,_RoleLv) when _RoleLv >= 630, _RoleLv =< 630 ->
		[{5,0,8357003100}];
get_reward(2,_RoleLv) when _RoleLv >= 631, _RoleLv =< 631 ->
		[{5,0,8391715400}];
get_reward(2,_RoleLv) when _RoleLv >= 632, _RoleLv =< 632 ->
		[{5,0,8426520300}];
get_reward(2,_RoleLv) when _RoleLv >= 633, _RoleLv =< 633 ->
		[{5,0,8461417900}];
get_reward(2,_RoleLv) when _RoleLv >= 634, _RoleLv =< 634 ->
		[{5,0,8496408200}];
get_reward(2,_RoleLv) when _RoleLv >= 635, _RoleLv =< 635 ->
		[{5,0,8531491400}];
get_reward(2,_RoleLv) when _RoleLv >= 636, _RoleLv =< 636 ->
		[{5,0,8566667500}];
get_reward(2,_RoleLv) when _RoleLv >= 637, _RoleLv =< 637 ->
		[{5,0,8601936800}];
get_reward(2,_RoleLv) when _RoleLv >= 638, _RoleLv =< 638 ->
		[{5,0,8637299300}];
get_reward(2,_RoleLv) when _RoleLv >= 639, _RoleLv =< 639 ->
		[{5,0,8672755100}];
get_reward(2,_RoleLv) when _RoleLv >= 640, _RoleLv =< 640 ->
		[{5,0,8708304400}];
get_reward(2,_RoleLv) when _RoleLv >= 641, _RoleLv =< 641 ->
		[{5,0,8743947100}];
get_reward(2,_RoleLv) when _RoleLv >= 642, _RoleLv =< 642 ->
		[{5,0,8779683600}];
get_reward(2,_RoleLv) when _RoleLv >= 643, _RoleLv =< 643 ->
		[{5,0,8815513700}];
get_reward(2,_RoleLv) when _RoleLv >= 644, _RoleLv =< 644 ->
		[{5,0,8851437800}];
get_reward(2,_RoleLv) when _RoleLv >= 645, _RoleLv =< 645 ->
		[{5,0,8887455800}];
get_reward(2,_RoleLv) when _RoleLv >= 646, _RoleLv =< 646 ->
		[{5,0,8923567900}];
get_reward(2,_RoleLv) when _RoleLv >= 647, _RoleLv =< 647 ->
		[{5,0,8959774200}];
get_reward(2,_RoleLv) when _RoleLv >= 648, _RoleLv =< 648 ->
		[{5,0,8996074800}];
get_reward(2,_RoleLv) when _RoleLv >= 649, _RoleLv =< 649 ->
		[{5,0,9032469800}];
get_reward(2,_RoleLv) when _RoleLv >= 650, _RoleLv =< 650 ->
		[{5,0,9068959300}];
get_reward(2,_RoleLv) when _RoleLv >= 651, _RoleLv =< 651 ->
		[{5,0,9105543400}];
get_reward(2,_RoleLv) when _RoleLv >= 652, _RoleLv =< 652 ->
		[{5,0,9142222300}];
get_reward(2,_RoleLv) when _RoleLv >= 653, _RoleLv =< 653 ->
		[{5,0,9178996100}];
get_reward(2,_RoleLv) when _RoleLv >= 654, _RoleLv =< 654 ->
		[{5,0,9215864700}];
get_reward(2,_RoleLv) when _RoleLv >= 655, _RoleLv =< 655 ->
		[{5,0,9252828500}];
get_reward(2,_RoleLv) when _RoleLv >= 656, _RoleLv =< 656 ->
		[{5,0,9289887400}];
get_reward(2,_RoleLv) when _RoleLv >= 657, _RoleLv =< 657 ->
		[{5,0,9327041600}];
get_reward(2,_RoleLv) when _RoleLv >= 658, _RoleLv =< 658 ->
		[{5,0,9364291200}];
get_reward(2,_RoleLv) when _RoleLv >= 659, _RoleLv =< 659 ->
		[{5,0,9401636300}];
get_reward(2,_RoleLv) when _RoleLv >= 660, _RoleLv =< 660 ->
		[{5,0,9439077000}];
get_reward(2,_RoleLv) when _RoleLv >= 661, _RoleLv =< 661 ->
		[{5,0,9476613400}];
get_reward(2,_RoleLv) when _RoleLv >= 662, _RoleLv =< 662 ->
		[{5,0,9514245600}];
get_reward(2,_RoleLv) when _RoleLv >= 663, _RoleLv =< 663 ->
		[{5,0,9551973800}];
get_reward(2,_RoleLv) when _RoleLv >= 664, _RoleLv =< 664 ->
		[{5,0,9589798000}];
get_reward(2,_RoleLv) when _RoleLv >= 665, _RoleLv =< 665 ->
		[{5,0,9627718300}];
get_reward(2,_RoleLv) when _RoleLv >= 666, _RoleLv =< 666 ->
		[{5,0,9665735000}];
get_reward(2,_RoleLv) when _RoleLv >= 667, _RoleLv =< 667 ->
		[{5,0,9703847900}];
get_reward(2,_RoleLv) when _RoleLv >= 668, _RoleLv =< 668 ->
		[{5,0,9742057400}];
get_reward(2,_RoleLv) when _RoleLv >= 669, _RoleLv =< 669 ->
		[{5,0,9780363400}];
get_reward(2,_RoleLv) when _RoleLv >= 670, _RoleLv =< 670 ->
		[{5,0,9818766200}];
get_reward(2,_RoleLv) when _RoleLv >= 671, _RoleLv =< 671 ->
		[{5,0,9857265700}];
get_reward(2,_RoleLv) when _RoleLv >= 672, _RoleLv =< 672 ->
		[{5,0,9895862100}];
get_reward(2,_RoleLv) when _RoleLv >= 673, _RoleLv =< 673 ->
		[{5,0,9934555600}];
get_reward(2,_RoleLv) when _RoleLv >= 674, _RoleLv =< 674 ->
		[{5,0,9973346200}];
get_reward(2,_RoleLv) when _RoleLv >= 675, _RoleLv =< 675 ->
		[{5,0,10012234000}];
get_reward(2,_RoleLv) when _RoleLv >= 676, _RoleLv =< 676 ->
		[{5,0,10051219100}];
get_reward(2,_RoleLv) when _RoleLv >= 677, _RoleLv =< 677 ->
		[{5,0,10090301700}];
get_reward(2,_RoleLv) when _RoleLv >= 678, _RoleLv =< 678 ->
		[{5,0,10129481900}];
get_reward(2,_RoleLv) when _RoleLv >= 679, _RoleLv =< 679 ->
		[{5,0,10168759700}];
get_reward(2,_RoleLv) when _RoleLv >= 680, _RoleLv =< 680 ->
		[{5,0,10208135300}];
get_reward(2,_RoleLv) when _RoleLv >= 681, _RoleLv =< 681 ->
		[{5,0,10247608800}];
get_reward(2,_RoleLv) when _RoleLv >= 682, _RoleLv =< 682 ->
		[{5,0,10287180300}];
get_reward(2,_RoleLv) when _RoleLv >= 683, _RoleLv =< 683 ->
		[{5,0,10326849800}];
get_reward(2,_RoleLv) when _RoleLv >= 684, _RoleLv =< 684 ->
		[{5,0,10366617600}];
get_reward(2,_RoleLv) when _RoleLv >= 685, _RoleLv =< 685 ->
		[{5,0,10406483700}];
get_reward(2,_RoleLv) when _RoleLv >= 686, _RoleLv =< 686 ->
		[{5,0,10446448200}];
get_reward(2,_RoleLv) when _RoleLv >= 687, _RoleLv =< 687 ->
		[{5,0,10486511200}];
get_reward(2,_RoleLv) when _RoleLv >= 688, _RoleLv =< 688 ->
		[{5,0,10526672900}];
get_reward(2,_RoleLv) when _RoleLv >= 689, _RoleLv =< 689 ->
		[{5,0,10566933300}];
get_reward(2,_RoleLv) when _RoleLv >= 690, _RoleLv =< 690 ->
		[{5,0,10607292600}];
get_reward(2,_RoleLv) when _RoleLv >= 691, _RoleLv =< 691 ->
		[{5,0,10647750800}];
get_reward(2,_RoleLv) when _RoleLv >= 692, _RoleLv =< 692 ->
		[{5,0,10688308100}];
get_reward(2,_RoleLv) when _RoleLv >= 693, _RoleLv =< 693 ->
		[{5,0,10728964600}];
get_reward(2,_RoleLv) when _RoleLv >= 694, _RoleLv =< 694 ->
		[{5,0,10769720400}];
get_reward(2,_RoleLv) when _RoleLv >= 695, _RoleLv =< 695 ->
		[{5,0,10810575500}];
get_reward(2,_RoleLv) when _RoleLv >= 696, _RoleLv =< 696 ->
		[{5,0,10851530200}];
get_reward(2,_RoleLv) when _RoleLv >= 697, _RoleLv =< 697 ->
		[{5,0,10892584400}];
get_reward(2,_RoleLv) when _RoleLv >= 698, _RoleLv =< 698 ->
		[{5,0,10933738400}];
get_reward(2,_RoleLv) when _RoleLv >= 699, _RoleLv =< 699 ->
		[{5,0,10974992200}];
get_reward(2,_RoleLv) when _RoleLv >= 700, _RoleLv =< 700 ->
		[{5,0,11016345900}];
get_reward(2,_RoleLv) when _RoleLv >= 701, _RoleLv =< 701 ->
		[{5,0,11057799600}];
get_reward(2,_RoleLv) when _RoleLv >= 702, _RoleLv =< 702 ->
		[{5,0,11099353500}];
get_reward(2,_RoleLv) when _RoleLv >= 703, _RoleLv =< 703 ->
		[{5,0,11141007700}];
get_reward(2,_RoleLv) when _RoleLv >= 704, _RoleLv =< 704 ->
		[{5,0,11182762200}];
get_reward(2,_RoleLv) when _RoleLv >= 705, _RoleLv =< 705 ->
		[{5,0,11224617200}];
get_reward(2,_RoleLv) when _RoleLv >= 706, _RoleLv =< 706 ->
		[{5,0,11266572700}];
get_reward(2,_RoleLv) when _RoleLv >= 707, _RoleLv =< 707 ->
		[{5,0,11308628900}];
get_reward(2,_RoleLv) when _RoleLv >= 708, _RoleLv =< 708 ->
		[{5,0,11350785900}];
get_reward(2,_RoleLv) when _RoleLv >= 709, _RoleLv =< 709 ->
		[{5,0,11393043800}];
get_reward(2,_RoleLv) when _RoleLv >= 710, _RoleLv =< 710 ->
		[{5,0,11435402700}];
get_reward(2,_RoleLv) when _RoleLv >= 711, _RoleLv =< 711 ->
		[{5,0,11477862800}];
get_reward(2,_RoleLv) when _RoleLv >= 712, _RoleLv =< 712 ->
		[{5,0,11520424000}];
get_reward(2,_RoleLv) when _RoleLv >= 713, _RoleLv =< 713 ->
		[{5,0,11563086500}];
get_reward(2,_RoleLv) when _RoleLv >= 714, _RoleLv =< 714 ->
		[{5,0,11605850500}];
get_reward(2,_RoleLv) when _RoleLv >= 715, _RoleLv =< 715 ->
		[{5,0,11648716000}];
get_reward(2,_RoleLv) when _RoleLv >= 716, _RoleLv =< 716 ->
		[{5,0,11691683200}];
get_reward(2,_RoleLv) when _RoleLv >= 717, _RoleLv =< 717 ->
		[{5,0,11734752100}];
get_reward(2,_RoleLv) when _RoleLv >= 718, _RoleLv =< 718 ->
		[{5,0,11777922900}];
get_reward(2,_RoleLv) when _RoleLv >= 719, _RoleLv =< 719 ->
		[{5,0,11821195600}];
get_reward(2,_RoleLv) when _RoleLv >= 720, _RoleLv =< 720 ->
		[{5,0,11864570400}];
get_reward(2,_RoleLv) when _RoleLv >= 721, _RoleLv =< 721 ->
		[{5,0,11908047400}];
get_reward(2,_RoleLv) when _RoleLv >= 722, _RoleLv =< 722 ->
		[{5,0,11951626700}];
get_reward(2,_RoleLv) when _RoleLv >= 723, _RoleLv =< 723 ->
		[{5,0,11995308300}];
get_reward(2,_RoleLv) when _RoleLv >= 724, _RoleLv =< 724 ->
		[{5,0,12039092500}];
get_reward(2,_RoleLv) when _RoleLv >= 725, _RoleLv =< 725 ->
		[{5,0,12082979300}];
get_reward(2,_RoleLv) when _RoleLv >= 726, _RoleLv =< 726 ->
		[{5,0,12126968800}];
get_reward(2,_RoleLv) when _RoleLv >= 727, _RoleLv =< 727 ->
		[{5,0,12171061100}];
get_reward(2,_RoleLv) when _RoleLv >= 728, _RoleLv =< 728 ->
		[{5,0,12215256300}];
get_reward(2,_RoleLv) when _RoleLv >= 729, _RoleLv =< 729 ->
		[{5,0,12259554500}];
get_reward(2,_RoleLv) when _RoleLv >= 730, _RoleLv =< 730 ->
		[{5,0,12303955900}];
get_reward(2,_RoleLv) when _RoleLv >= 731, _RoleLv =< 731 ->
		[{5,0,12348460600}];
get_reward(2,_RoleLv) when _RoleLv >= 732, _RoleLv =< 732 ->
		[{5,0,12393068600}];
get_reward(2,_RoleLv) when _RoleLv >= 733, _RoleLv =< 733 ->
		[{5,0,12437780000}];
get_reward(2,_RoleLv) when _RoleLv >= 734, _RoleLv =< 734 ->
		[{5,0,12482595000}];
get_reward(2,_RoleLv) when _RoleLv >= 735, _RoleLv =< 735 ->
		[{5,0,12527513700}];
get_reward(2,_RoleLv) when _RoleLv >= 736, _RoleLv =< 736 ->
		[{5,0,12572536200}];
get_reward(2,_RoleLv) when _RoleLv >= 737, _RoleLv =< 737 ->
		[{5,0,12617662600}];
get_reward(2,_RoleLv) when _RoleLv >= 738, _RoleLv =< 738 ->
		[{5,0,12662892900}];
get_reward(2,_RoleLv) when _RoleLv >= 739, _RoleLv =< 739 ->
		[{5,0,12708227300}];
get_reward(2,_RoleLv) when _RoleLv >= 740, _RoleLv =< 740 ->
		[{5,0,12753666000}];
get_reward(2,_RoleLv) when _RoleLv >= 741, _RoleLv =< 741 ->
		[{5,0,12799208900}];
get_reward(2,_RoleLv) when _RoleLv >= 742, _RoleLv =< 742 ->
		[{5,0,12844856300}];
get_reward(2,_RoleLv) when _RoleLv >= 743, _RoleLv =< 743 ->
		[{5,0,12890608200}];
get_reward(2,_RoleLv) when _RoleLv >= 744, _RoleLv =< 744 ->
		[{5,0,12936464700}];
get_reward(2,_RoleLv) when _RoleLv >= 745, _RoleLv =< 745 ->
		[{5,0,12982426000}];
get_reward(2,_RoleLv) when _RoleLv >= 746, _RoleLv =< 746 ->
		[{5,0,13028492100}];
get_reward(2,_RoleLv) when _RoleLv >= 747, _RoleLv =< 747 ->
		[{5,0,13074663100}];
get_reward(2,_RoleLv) when _RoleLv >= 748, _RoleLv =< 748 ->
		[{5,0,13120939200}];
get_reward(2,_RoleLv) when _RoleLv >= 749, _RoleLv =< 749 ->
		[{5,0,13167320500}];
get_reward(2,_RoleLv) when _RoleLv >= 750, _RoleLv =< 750 ->
		[{5,0,13213807000}];
get_reward(2,_RoleLv) when _RoleLv >= 750, _RoleLv =< 9999 ->
		[{5,0,13213807000}];
get_reward(_Type,_RoleLv) ->
	0.

