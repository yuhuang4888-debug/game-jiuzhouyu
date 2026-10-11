/** 本服BOSS信息
 */
declare interface ProtoFmtInfo {
    46000: {
        desc: "BOSS列表信息";
        send: (
            number: 46000,
            fmt: "c",
            args: [
                /**boss类型*/
                boss_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**boss类型*/
            boss_type: number
        ];
        recv: {
            boss_type: number;
            /** 总的进入次数 */
            all_count: number;
            /** 剩余进入次数 */
            count: number;
            /** boss的剩余疲劳值 */
            tired: number;
            /** 总的疲劳值 */
            all_tired: number;
            /** 体力值 */
            vit: number;
            /** 上次计算的体力值 */
            last_vit_time: number;
            /** 已采集次数 */
            collect_times: number;
            /** 总采集次数 */
            all_collect_times: number;
            boss_info: {
                /** BossId */
                boss_id: number;
                /** 怪数量  %% 幻兽领宝箱: 已被采集次数 */
                num: number;
                /** 复活结束时间戳：0|>0 */
                reborn_time: number;
                /** 是否关注：0|1 */
                is_remind: number;
                /** 是否可以触发自动关注 0否 | 1是 */
                auto_remind: number;
            }[];
        };
    };
    46001: {
        desc: "BOSS击杀记录";
        send: (
            number: 46001,
            fmt: "ci",
            args: [boss_type: number, boss_id: number]
        ) => never;
        sendFmt: "ci";
        sendArgs: [boss_type: number, boss_id: number];
        recv: {
            kill_log: {
                /** 击杀时间 */
                time: number;
                /** 玩家id */
                role_id: number;
                /**  击杀名字 */
                name: string;
            }[];
        };
    };
    46002: {
        desc: "BOSS掉落记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            drop_log: {
                time: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                name: string;
                /** boss类型 */
                boss_type: number;
                /** bossid */
                boss_id: number;
                /** 物品类型id */
                goods_id: number;
                /** 数量 */
                num: number;
                /** 装备评分 */
                rating: number;
                /** 装备附加属性(极品属性) */
                equip_extra_attr: {
                    /** 颜色 参考后台颜色配置 */
                    color: number;
                    /** 类型 1: 成长型属性 2: 百分比加成属性 */
                    type_id: number;
                    /** 属性类型 */
                    attr_id: number;
                    /** 属性值 */
                    attr_val: number;
                    /** 每多少级增加(成长型属性使用) */
                    plus_interval: number;
                    /** 每隔多少级增加多少属性(成长型属性使用) */
                    plus_unit: number;
                }[];
                /** 是否置顶 */
                is_top: number;
            }[];
        };
    };
    46003: {
        desc: "进入本服BOSS";
        send: (
            number: 46003,
            fmt: "ci",
            args: [boss_type: number, boss_id: number]
        ) => never;
        sendFmt: "ci";
        sendArgs: [boss_type: number, boss_id: number];
        recv: {
            code: number;
        };
    };
    46004: {
        desc: "退出本服BOSS";
        send: (number: 46004, fmt: "c", args: [boss_type: number]) => never;
        sendFmt: "c";
        sendArgs: [boss_type: number];
        recv: {
            code: number;
        };
    };
    46005: {
        desc: "蛮荒禁地BOSS怒气";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 蛮荒怒气值 */
            anger: number;
            /** 蛮荒最大怒气值 */
            max_anger: number;
        };
    };
    46006: {
        desc: "蛮荒禁地满怒退出倒计时";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1:雷霆之怒倒计时;2:退出倒计时 */
            type: number;
            /** 蛮荒禁地满怒退出倒计时 */
            tickout_time: number;
        };
    };
    46007: {
        desc: "本服BOSS关注|取消关注操作";
        send: (
            number: 46007,
            fmt: "cicc",
            args: [
                boss_type: number,
                boss_id: number,
                /**是否关注0|1*/
                remind: number,
                /**是否自动操作 0否 | 1是*/
                is_auto: number
            ]
        ) => never;
        sendFmt: "cicc";
        sendArgs: [
            boss_type: number,
            boss_id: number,
            /**是否关注0|1*/
            remind: number,
            /**是否自动操作 0否 | 1是*/
            is_auto: number
        ];
        recv: {
            code: number;
            boss_type: number;
            boss_id: number;
            remind: number;
            is_auto: number;
        };
    };
    46008: {
        desc: "本服BOSS重生提醒";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss_type: number;
            boss_id: number;
        };
    };
    46009: {
        desc: "BOSS被击杀信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss_type: number;
            /** BossId */
            boss_id: number;
            /** 复活结束时间戳 */
            reborn_time: number;
            /** 剩余活着的数量1 */
            num: number;
        };
    };
    46010: {
        desc: "蛮荒BOSS的小怪信息";
        send: (number: 46010, fmt: "c", args: [boss_type: number]) => never;
        sendFmt: "c";
        sendArgs: [boss_type: number];
        recv: {
            boss_type: number;
            scene: number;
            mon_ids: {
                mon_id: number;
                x: number;
                y: number;
            }[];
        };
    };
    46011: {
        desc: "世界BOSS的疲劳值更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss_tired: number;
        };
    };
    46012: {
        desc: "上古神庙随机怪坐标";
        send: (
            number: 46012,
            fmt: "ci",
            args: [boss_type: number, boss_id: number]
        ) => never;
        sendFmt: "ci";
        sendArgs: [boss_type: number, boss_id: number];
        recv: {
            code: number;
            boss_id: number;
            x: number;
            y: number;
        };
    };
    46013: {
        desc: "怪物重生信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss_type: number;
            /** BossId */
            boss_id: number;
            num: number;
        };
    };
    46014: {
        desc: "刷新已被杀的本服boss(个人boss除外)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    46015: {
        desc: "结算奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 奖励类型##1:归属 2:普通 */
            reward_type: number;
            reward_list: {
                /** 类型 */
                type: number;
                /** 物品类型 */
                goods_type_id: number;
                /** 物品数量 */
                num: number;
                /** 唯一id */
                id: number;
            }[];
        };
    };
    46016: {
        desc: "本服BOSS复活提醒";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** boss类型 */
            boss_type: number;
            /** bossid */
            boss_id: number;
        };
    };
    46017: {
        desc: "世界boss入口";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1表示打开，图标显示，其他表示不显示 */
            show_icon: number;
        };
    };
    46018: {
        desc: "进入世界boss场景";
        send: (
            number: 46018,
            fmt: "ci",
            args: [
                /**boss类型*/
                boss_type: number,
                /**bossid*/
                boss_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**boss类型*/
            boss_type: number,
            /**bossid*/
            boss_id: number
        ];
        recv: {
            code: number;
        };
    };
    46019: {
        desc: "世界boss伤害排名";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 这个列表最多3个玩家的 */
            rank: {
                role_name: string;
                damage: number;
            }[];
        };
    };
    46020: {
        desc: "世界boss鼓舞";
        send: (
            number: 46020,
            fmt: "c",
            args: [
                /**鼓舞类型，1 表示货币1，2 表示货币2*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**鼓舞类型，1 表示货币1，2 表示货币2*/
            type: number
        ];
        recv: {
            /** 1表示成功 */
            code: number;
            /** 货币1剩余次数 */
            times1: number;
            /** 货币2剩余次数 */
            times2: number;
        };
    };
    46021: {
        desc: "世界boss结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 第一名名字 */
            firstName: string;
            /** 第一名伤害 */
            firstDamage: number;
            /** 击杀者名字 */
            attrName: string;
            /** 排名 */
            self_rank: number;
            /** 等级 */
            lv: number;
            /** 玩家名字 */
            name: string;
            /** 性别 */
            sex: number;
            /** 阵营 */
            realm: number;
            /** 职业 */
            career: number;
            /** 等级 */
            level: number;
            /** 是否GM */
            GM: number;
            /** VIP */
            vip_flag: number;
            /** 职称 */
            touxian: number;
            /** 等级模型 */
            level_model_list: {
                /** 部位 */
                part_pos: number;
                /** 模型id */
                level_model_id: number;
            }[];
            /** 时装模型 */
            fashion_model_list: {
                /** 部位 */
                part_pos: number;
                /** 模型id */
                fashion_model_id: number;
                figure_chartlet_id: number;
            }[];
            /** 自定义头像url */
            picture: string;
            /** 自定义头像版本号 */
            prcture_ver: number;
            /** 帮派id */
            guild_id: number;
            /** 帮派名字 */
            guild_name: string;
            /** 帮派职位 */
            position: number;
            /** 帮派职位名字 */
            position_name: string;
            /** 称号 */
            dsgt_id: number;
            /** 活跃度形象Id */
            image_id: number;
            /** 转生次数 */
            turn: number;
            /** 转生阶段 */
            turn_stage: number;
            /** 爵位等级 */
            grade_id: number;
            /** 结婚状态 0单身 1情侣 2结婚 */
            is_marriage: number;
            /** 伴侣玩家id */
            marriage_id: number;
            /** 伴侣玩家name */
            marriage_name: string;
            /** 护送天使id */
            escort_state: number;
            /** 房子街区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 房子等级 */
            house_lv: number;
            /** 幻化模型 */
            figure_list: {
                /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                figure_type: number;
                /** 模型id */
                figure_id: number;
                figure_chartlet_id: number;
            }[];
            /** 幻化模型是否骑乘##找不到数据就默认骑乘 */
            figure_ride_list: {
                /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                figure_type: number;
                /** 是否骑乘(用于场景表现,点击头像等等忽略本字段) */
                is_ride: number;
            }[];
            /** 成就等级 */
            achv_lv: number;
            /** 勋章id */
            medal_id: number;
            /** 法阵id */
            fazhen_id: number;
            /** 装扮列表 */
            dress_list: {
                /** 装扮类型 */
                dress_type: number;
                /** 装扮id */
                dress_id: number;
            }[];
            /** 将神id */
            god_id: number;
            /** 天启套装 */
            revelation_suit: number;
            /** 使魔id */
            demon_id: number;
            /** 是否有至尊vip标识 */
            supreme_vip: number;
            /** 头衔id */
            title_id: number;
            /** 蒙面id */
            mask_id: number;
            /** 阵营四海争霸(玩家阵营) */
            seaCamp: number;
            /** 海战日常砖块品质 */
            brick_id: number;
            /** 假人类型（0:玩家） */
            dummy_type: number;
            /** 套装贴图id */
            suit_fashion_id: number;
            /** 采集状态 （0：非采集， 1：采集中） */
            collect_state: number;
            /** 奖励 */
            reward: {
                type: number;
                goodtypeid: number;
                num: number;
            }[];
        };
    };
    46022: {
        desc: "世界boss伤害";
        send: (
            number: 46022,
            fmt: "ci",
            args: [
                /**boss类型*/
                boss_type: number,
                /**bossid*/
                boss_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**boss类型*/
            boss_type: number,
            /**bossid*/
            boss_id: number
        ];
        recv: {
            /** 自己的排名 */
            self_rank: number;
            /** 伤害 */
            self_damage: number;
            /** 名字 */
            self_name: string;
            /** 与上一名的差距 */
            distance: number;
        };
    };
    46023: {
        desc: "世界boss状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss: {
                bossid: number;
                /** 0表示死亡，1表示还活着 */
                boss_status: number;
            }[];
        };
    };
    46024: {
        desc: "连杀";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 玩家名字 */
            name: string;
            /** 性别 */
            sex: number;
            /** 阵营 */
            realm: number;
            /** 职业 */
            career: number;
            /** 等级 */
            level: number;
            /** 是否GM */
            GM: number;
            /** VIP */
            vip_flag: number;
            /** 职称 */
            touxian: number;
            /** 等级模型 */
            level_model_list: {
                /** 部位 */
                part_pos: number;
                /** 模型id */
                level_model_id: number;
            }[];
            /** 时装模型 */
            fashion_model_list: {
                /** 部位 */
                part_pos: number;
                /** 模型id */
                fashion_model_id: number;
                figure_chartlet_id: number;
            }[];
            /** 自定义头像url */
            picture: string;
            /** 自定义头像版本号 */
            prcture_ver: number;
            /** 帮派id */
            guild_id: number;
            /** 帮派名字 */
            guild_name: string;
            /** 帮派职位 */
            position: number;
            /** 帮派职位名字 */
            position_name: string;
            /** 称号 */
            dsgt_id: number;
            /** 活跃度形象Id */
            image_id: number;
            /** 转生次数 */
            turn: number;
            /** 转生阶段 */
            turn_stage: number;
            /** 爵位等级 */
            grade_id: number;
            /** 结婚状态 0单身 1情侣 2结婚 */
            is_marriage: number;
            /** 伴侣玩家id */
            marriage_id: number;
            /** 伴侣玩家name */
            marriage_name: string;
            /** 护送天使id */
            escort_state: number;
            /** 房子街区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 房子等级 */
            house_lv: number;
            /** 幻化模型 */
            figure_list: {
                /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                figure_type: number;
                /** 模型id */
                figure_id: number;
                figure_chartlet_id: number;
            }[];
            /** 幻化模型是否骑乘##找不到数据就默认骑乘 */
            figure_ride_list: {
                /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                figure_type: number;
                /** 是否骑乘(用于场景表现,点击头像等等忽略本字段) */
                is_ride: number;
            }[];
            /** 成就等级 */
            achv_lv: number;
            /** 勋章id */
            medal_id: number;
            /** 法阵id */
            fazhen_id: number;
            /** 装扮列表 */
            dress_list: {
                /** 装扮类型 */
                dress_type: number;
                /** 装扮id */
                dress_id: number;
            }[];
            /** 将神id */
            god_id: number;
            /** 天启套装 */
            revelation_suit: number;
            /** 使魔id */
            demon_id: number;
            /** 是否有至尊vip标识 */
            supreme_vip: number;
            /** 头衔id */
            title_id: number;
            /** 蒙面id */
            mask_id: number;
            /** 阵营四海争霸(玩家阵营) */
            seaCamp: number;
            /** 海战日常砖块品质 */
            brick_id: number;
            /** 假人类型（0:玩家） */
            dummy_type: number;
            /** 套装贴图id */
            suit_fashion_id: number;
            /** 采集状态 （0：非采集， 1：采集中） */
            collect_state: number;
            /** 当前连杀 */
            dkill: number;
        };
    };
    46025: {
        desc: "个人信息推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            info_list: {
                /** 4 采集次数 */
                key: number;
                /** 值 */
                val: number;
            }[];
        };
    };
    46026: {
        desc: "节日boss隐藏宝箱推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            box_list: {
                /** 宝箱id */
                box_id: number;
            }[];
        };
    };
    46027: {
        desc: "节日boss宝箱生成广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** boss唯一id */
            boss_id: number;
            /** bossx坐标 */
            boss_x: number;
            /** bossy坐标 */
            boss_y: number;
            box_list: {
                /** X坐标 */
                x: number;
                /** Y坐标 */
                y: number;
                /** 唯一标识 */
                auto_id: number;
                /** 怪物ID */
                mon_cfg_id: number;
                /** hp */
                hp: number;
                /** hp_lim */
                hp_lim: number;
                /** 等级 */
                lv: number;
                /** 名字 */
                name: string;
                /** 速度 */
                sp: number;
                /** 怪物资源 */
                mon_resource: number;
                /** 特效资源id */
                mon_res: string;
                /** 贴图id */
                imag_id: number;
                /** 武器id */
                weapon_id: number;
                /** 0进战 1远程 */
                att_type: number;
                /** 类型: 0怪物，1采集怪，2任务采集怪，3护送车队，4拾取型，5赏金怪...（见宏定义） */
                kind: number;
                /** 0白1绿2蓝3紫4橙 */
                color: number;
                /** 是否挂机：0是，1否 */
                on_hook: number;
                /** BOSS类型 0普通怪，1野外BOSS，2英灵殿BOSS...（见宏定义） */
                boss: number;
                /** 采集所需时间 */
                collect_time: number;
                /** 是否可点击(0 不可点击， 1可点击) */
                is_be_clicked: number;
                /** 是否可攻击(0 不可攻击， 1可攻击) */
                is_be_atted: number;
                /** 是否隐身(0否，1是) */
                hide: number;
                /** 是否幽灵(0否, 1是) */
                ghost: number;
                /** 分组id */
                mon_group: number;
                /** 所属公会id */
                guild_id: number;
                /** 出生角度 (1-360) */
                Angel: number;
                /** 五行 */
                attr_type: number;
                /** 头衔(天空战场头衔|其他) */
                title: number;
            }[];
        };
    };
    46028: {
        desc: "节日boss结算推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0失败 1成功 */
            code: number;
            reward_list: any;
        };
    };
    46029: {
        desc: "节日boss全部击杀";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    46030: {
        desc: "广播归属";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 玩家名字 */
            name: string;
            /** 性别 */
            sex: number;
            /** 阵营 */
            realm: number;
            /** 职业 */
            career: number;
            /** 等级 */
            level: number;
            /** 是否GM */
            GM: number;
            /** VIP */
            vip_flag: number;
            /** 职称 */
            touxian: number;
            /** 等级模型 */
            level_model_list: {
                /** 部位 */
                part_pos: number;
                /** 模型id */
                level_model_id: number;
            }[];
            /** 时装模型 */
            fashion_model_list: {
                /** 部位 */
                part_pos: number;
                /** 模型id */
                fashion_model_id: number;
                figure_chartlet_id: number;
            }[];
            /** 自定义头像url */
            picture: string;
            /** 自定义头像版本号 */
            prcture_ver: number;
            /** 帮派id */
            guild_id: number;
            /** 帮派名字 */
            guild_name: string;
            /** 帮派职位 */
            position: number;
            /** 帮派职位名字 */
            position_name: string;
            /** 称号 */
            dsgt_id: number;
            /** 活跃度形象Id */
            image_id: number;
            /** 转生次数 */
            turn: number;
            /** 转生阶段 */
            turn_stage: number;
            /** 爵位等级 */
            grade_id: number;
            /** 结婚状态 0单身 1情侣 2结婚 */
            is_marriage: number;
            /** 伴侣玩家id */
            marriage_id: number;
            /** 伴侣玩家name */
            marriage_name: string;
            /** 护送天使id */
            escort_state: number;
            /** 房子街区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 房子等级 */
            house_lv: number;
            /** 幻化模型 */
            figure_list: {
                /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                figure_type: number;
                /** 模型id */
                figure_id: number;
                figure_chartlet_id: number;
            }[];
            /** 幻化模型是否骑乘##找不到数据就默认骑乘 */
            figure_ride_list: {
                /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                figure_type: number;
                /** 是否骑乘(用于场景表现,点击头像等等忽略本字段) */
                is_ride: number;
            }[];
            /** 成就等级 */
            achv_lv: number;
            /** 勋章id */
            medal_id: number;
            /** 法阵id */
            fazhen_id: number;
            /** 装扮列表 */
            dress_list: {
                /** 装扮类型 */
                dress_type: number;
                /** 装扮id */
                dress_id: number;
            }[];
            /** 将神id */
            god_id: number;
            /** 天启套装 */
            revelation_suit: number;
            /** 使魔id */
            demon_id: number;
            /** 是否有至尊vip标识 */
            supreme_vip: number;
            /** 头衔id */
            title_id: number;
            /** 蒙面id */
            mask_id: number;
            /** 阵营四海争霸(玩家阵营) */
            seaCamp: number;
            /** 海战日常砖块品质 */
            brick_id: number;
            /** 假人类型（0:玩家） */
            dummy_type: number;
            /** 套装贴图id */
            suit_fashion_id: number;
            /** 采集状态 （0：非采集， 1：采集中） */
            collect_state: number;
        };
    };
    46031: {
        desc: "秘境boss宝箱界面";
        send: (number: 46031, fmt: "i", args: [boss_id: number]) => never;
        sendFmt: "i";
        sendArgs: [boss_id: number];
        recv: {
            boss_id: number;
            /** 归属者id */
            role_id: number;
            /** 归属者名字 */
            name: string;
            /** 归属者职业 */
            career: number;
            /** 归属者等级 */
            lv: number;
            /** 归属者战力 */
            combat: number;
            /** 归属者头像 */
            picture: string;
            /** 归属者头像 */
            picture_ver: number;
            /** 结束时间戳 */
            time: number;
            /** 当前抽奖次数 */
            curtimes: number;
            /** 抽奖次数限制 */
            limit_times: number;
        };
    };
    46032: {
        desc: "秘境boss宝箱抽奖";
        send: (
            number: 46032,
            fmt: "ic",
            args: [
                boss_id: number,
                /**抽奖类型：1钻石，2绑钻*/
                type: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            boss_id: number,
            /**抽奖类型：1钻石，2绑钻*/
            type: number
        ];
        recv: {
            code: number;
            boss_id: number;
            reward_list: any;
        };
    };
    46033: {
        desc: "节日boss波数信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            next_wave: number;
            time: number;
        };
    };
    46034: {
        desc: "新野外boss玩家死亡次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 死亡次数 */
            die_times: number;
            /** 死亡等待结束时间（可以免费复活时间） */
            time: number;
            /** debuff持续时间 */
            debuff_time: number;
            /** 玩家回安全区时间（把尸体挪回复活点时间） */
            safe_time: number;
        };
    };
    46035: {
        desc: "重连";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** boss类型 */
            boss_type: number;
            /** 层级 */
            layer: number;
        };
    };
    46036: {
        desc: "宝箱信息更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** boss类型 */
            boss_id: number;
            xylist: {
                x: number;
                y: number;
            }[];
        };
    };
    46037: {
        desc: "获取秘境领域阶段奖励状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 击杀boss数量 */
            kill_num: number;
            had_reward_list: {
                /** 已领取的阶段 */
                stage: number;
            }[];
        };
    };
    46038: {
        desc: "秘境领域阶段领取奖励";
        send: (
            number: 46038,
            fmt: "i",
            args: [
                /**奖励id*/
                reward_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**奖励id*/
            reward_id: number
        ];
        recv: {
            /** 奖励id */
            reward_id: number;
            /** 错误码 1：成功 */
            code: number;
        };
    };
    46039: {
        desc: "进场景宝箱信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            info: {
                boss_id: number;
                xylist: {
                    x: number;
                    y: number;
                }[];
            }[];
        };
    };
    46040: {
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** boss类型id */
                mon_id: number;
                /** boss唯一id */
                auto_id: number;
                /** 当前血量 */
                hp: number;
                /** 血量上限 */
                hp_max: number;
            }[];
        };
    };
    46041: {
        desc: "复活boss";
        send: (
            number: 46041,
            fmt: "ci",
            args: [boss_type: number, boss_id: number]
        ) => never;
        sendFmt: "ci";
        sendArgs: [boss_type: number, boss_id: number];
        recv: {
            errcode: number;
            boss_type: number;
            boss_id: number;
        };
    };
    46042: {
        desc: "主动复活boss通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss_type: number;
            boss_id: number;
        };
    };
    46043: {
        desc: "boss体力值变化";
        send: (
            number: 46043,
            fmt: "c",
            args: [
                /**boss类型*/
                boss_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**boss类型*/
            boss_type: number
        ];
        recv: null;
    };
    46044: {
        desc: "boss体力值";
        send: (
            number: 46044,
            fmt: "c",
            args: [
                /**boss类型*/
                boss_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**boss类型*/
            boss_type: number
        ];
        recv: {
            /** 体力值 */
            vit: number;
            /** 最大体力值 */
            max_vit: number;
            /** 上次计算的体力值时间 */
            last_vit_time: number;
        };
    };
}
