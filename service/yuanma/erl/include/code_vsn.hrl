%% ---------------------------------------------------------------------------
%% @doc code_vsn.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2022年3月28日
%% @deprecated 代码版本：区分国内版本，本头文件不会自动同步，需要手动提交
%%  2022年3月28日：第一次同步需要检查一下相关的同步脚本
%%  X年X月X日：已经检查完毕相关的同步脚本
%% ---------------------------------------------------------------------------

%% NOTE:防止外服使用到正式服配置，最终是需要使用 lib_vsn:is_sy_internal_devp() 配合使用判断是否正式环境

%% 内部区分
-define(CODE_BRANCH_LOCAL,          local).             % 本地(隔绝开发服)
-define(CODE_BRANCH_DEVELOP,        develop).           % 开发
-define(CODE_BRANCH_PRE_STABLE,     pre_stable).        % 体验
-define(CODE_BRANCH_INTERNAL,       internal).          % 内部版本(不做区分)
-define(CODE_BRANCH_INTERNAL_SHENHAI,   internal_shenhai).      % 内部-深海版本
%% 正式
-define(CODE_BRANCH_OFFICIAL,       official).          % 正式服-普通
-define(CODE_BRANCH_SHENHAI,        shenhai).           % 正式服-深海
-define(CODE_BRANCH_WX,             wx).                % 正式服-小程序

%% 分支
% -define(CODE_BRANCH, ?CODE_BRANCH_DEVELOP).
-define(CODE_BRANCH, ?CODE_BRANCH_OFFICIAL).