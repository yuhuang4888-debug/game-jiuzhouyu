%%-----------------------------------------------------------------------------
%% @Module  :       kv.hrl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-01-20
%% @Description:    全局KV配置 键定义
%%-----------------------------------------------------------------------------

-define (KEY_DOWNLOAD_GIFT, 1). %% 下载礼包
-define (KEY_SHARE_RESET_TIME, 2). %% 分享有礼重置时间
-define (KEY_SHARE_REWARD, 3). %% 分享有礼奖励
-define (KEY_SHARE_LV, 4). %% 分享有礼开启等级
-define (KEY_SHARE_TITLE, 5). %% 分享有礼分享标题
-define (KEY_SHARE_CONTENT, 6). %% 分享有礼分享内容
-define (KEY_SHARE_URL, 7). %% 分享有礼分享链接
% -define (KEY_RECHARGE_FIRST_MAIL_LV, 12). %% 添加有礼邮件发送等级
% -define (KEY_RECHARGE_FIRST_MAIL_GOLD, 13). %% 添加有礼充值触发金额
% -define (KEY_RECHARGE_FIRST_SOURCES, 15). %% 添加有礼生效渠道
-define(KEY_RUSH_CHANGE_OPEN_TIME, 16).           %% 开服冲榜规则变换开服时间
-define(KEY_SERVER_LOGIN_LIMIT_TIME, 17). % 服务器限制登录时间段

-define (KEY_FIVE_STAR_LV_ID, 3310001). %% 五星评价开放等级
-define (KEY_DOWNLOAD_GIFT_LV_ID, 4170001). %% 下载礼包开放等级id

-define (KEY_BEACH_KF_DAY, 4180001).  %% 魅力海滩多少天后进入跨服
-define (KEY_BEACH_GIFT_COUNT_PRICE, 4180002).  %% 魅力海滩购买赠送次数价格（铜币
-define (KEY_BEACH_EXP_TIME, 4180003).  %% 魅力海滩获得经验时间间隔（秒）
-define (KEY_BEACH_TIME_BEFORE_END, 4180004).  %% 魅力海滩结算到结束的时间
-define (KEY_BEACH_FIRST_TITLE, 4180005).  %% 魅力海滩第一名称号
-define (KEY_BEACH_GIFT_TV_TIME, 4180006).  %% 海滩提示送礼间隔次数{间隔(秒),次数}
-define (KEY_BEACH_GIFT_FREE_TIMES, 4180007).  %% 海滩免费送礼次数
