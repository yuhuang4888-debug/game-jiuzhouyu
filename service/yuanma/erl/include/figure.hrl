%% ---------------------------------------------------------------------------
%% @doc 角色形象记录
%% @author ming_up@foxmail.com
%% @since  2016-04-06
%% @deprecated 角色外观形象 此形象为场景中外观形象，并不包含ui中的形象字段
%% ---------------------------------------------------------------------------
-record(figure, {
          name="",                                % 角色昵称
          sex = 0,                                % 性别 1男 2女
          realm = 0,                              % 阵营
          career = 0,                             % 职业
          lv = 1,                                 % 等级
          gm = 0,                                 % 是否GM(0:不是GM,1:GM)
          vip = 0,                                % VIP等级
          vip_type = 0,                           % VIP特权类型
          vip_hide = 0,                           % vip是否隐藏
          body = 0,                               % 身上形象（人物：衣服，怪物：资源id）
          title=0,                                % 怪物蓝白旗标识
          robot_type = 0,                         % 假人类型
          lv_model = [],                          % 等级模型[{部位, 模型id}]
          fashion_model = [],                     % 时装模型[{部位, 模型id, 颜色id}]
          picture = "",                           % 玩家上传的头像地址(默认是玩家id)
          picture_ver = 0,                        % 玩家上传的头像版本号
          guild_id = 0,                           % 公会id
          guild_name = <<>>,                      % 公会名字
          position = 0,                           % 公会职位
          position_name = "",                     % 公会职位名字
          is_collecting = 0,                      % 是否在采集(暂时只在场景进程处理)
          %% sec_position = 0,                       % 公会第二职位
          %% sec_position_name = "",                 % 公会第二职位名字
          designation = 0,                        % 玩家称号id
          %% designation_name = "",                  % 玩家称号名
          weapon_effect = 0,                      % 武器附魔光效
          wing_figure = 0,                        % 翅膀id
          dress_list = [],                        % 个性装扮[{装扮类型, 装扮id}]
          liveness = 0,                           % 活跃度形象Id
                                                  % - liveness的形象Id现在由龙珠/星核(dragon_ball)的神龙附体直接使用
          fairy_figure = 0,                       % 圣物
          turn = 0,                               % 转生次数（01234）
          turn_stage = 0,                         % 转生阶段
          juewei_lv = 0,                          % 爵位等级
          god_equip_model = [],                   % 神装模型[{部位, 模型id}]
          marriage_type = 0,                      % 0单身 1情侣 2结婚
          lover_role_id = 0,                      % 伴侣玩家id
          lover_name = "",                        % 伴侣玩家名字
          baby_id = 0,                            % 宝宝形象
          baby_if_show = 0,                       % 宝宝形象是否显示（0不显示 1显示）
          husong_angel_id = 0,                    % 护送天使id
          lb_pet_figure = 0,                      % 宠物排行榜形象id 只有lib_role缓存里面的figure是有数据的
          lb_mount_figure = 0,                    % 坐骑排行榜形象id 只有lib_role缓存里面的figure是有数据的
          home_id = {0, 0},                       % 家园id
          house_lv = 0,                           % 房子等级
          h_ghost_figure = 0,                     % 圣灵形象id
          h_ghost_display = 0,                    % 圣灵显示状态(1显示 0隐藏)
          mount_figure = [],                      % 外形培养[{外形类型,形象id}]  外形类型（1:坐骑 2：伙伴 3: 翅膀  4:神器【跟着主角飞】 5：圣器【人物武器】 6：精灵【跟着主角飞】 7：宠物【飞行器/伙伴的坐骑】 12: 新版背饰系统）
          mount_figure_ride = [],                 % 是否骑乘[{外形类型,IsRide}]
          achiv_stage = 0,                        % 成就等级
          medal_id = 0                            % 勋章id
          ,magic_circle_figure = 0                % 魔法阵形象id
          ,god_id = 0                             % 降神形象
          ,demons_id = 0                          % 使魔id
          ,revelation_suit = 0                    % 天启套装形象
          ,is_supvip = 0                          % 是否有至尊vip标识##过期的话,离线数据有可能没更新到。在线则会更新数据
          % ,supvip_type = 0                        % 至尊vip类型
          % ,supvip_time = 0                        % 至尊vip时间
          ,back_decora_figure = []                %背饰类型（类型和mount_figure 一致，pt:wirte_figure时添加进去）
          ,back_decora_figure_ride = []           %背饰骑行（类型和mount_figure_ride 一致，pt:wirte_figure时添加进去）
          ,title_id = 0                   % 头衔id
          ,mask_id = 0                      % 面罩id
          ,camp = 0                               % 阵营/四海争霸(玩家阵营)
          ,exploit = 0                            % 阵营/四海争霸功勋
          ,brick_color = 0                        % 海战日常砖块品质
          ,suit_clt_figure = 0                   % 套装收集形象（套装id）
}).
