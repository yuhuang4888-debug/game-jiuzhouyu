%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% 外文版本SVI需求
%%% @end
%%% Created : 16. 8月 2022 11:31
%%%-------------------------------------------------------------------


-define(SVIP_ADVERTISING_SLOGAN,  1).   %% SVIP广告语
-define(SVIP_PICTURE_CONTENT,     2).   %% SVIP图片内容
-define(SVIP_PRIVILEGED_CONTENT,  3).   %% SVIP特权内容
-define(SVIP_CONTACT_CONTENT,     4).   %% SVIP联系方式

-record(base_english_super_vip,{
    act_id = 0,              %% 活动ID
    start_time = 0,          %% 活动开始时间
    end_time = 0,            %% 活动开始时间
    condition = [],          %% 活动开始条件
    ad_content = [],         %% 广告语({[渠道列表],[渠道开放的图片ID列表]})
    pic_content = [],        %% 图片({[渠道列表],[渠道开放的图片资源ID列表]})
    pri_content = [],        %% 特权内容({[渠道列表],[渠道开放的特权ID列表]})
    con_content = []         %% 联系方式({[渠道列表],[渠道开放的图片ID列表]})
}).
