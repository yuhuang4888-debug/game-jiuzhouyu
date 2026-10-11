/** 公会信息
 */
declare interface ProtoFmtInfo {
    40000: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    40001: {
        desc: "公会列表界面";
        send: (
            number: 40001,
            fmt: "shh",
            args: [
                /** 公会名字*/
                guild_name: string,
                /**页大小*/
                page_size: number,
                /**页号*/
                page_no: number
            ]
        ) => never;
        sendFmt: "shh";
        sendArgs: [
            /** 公会名字*/
            guild_name: string,
            /**页大小*/
            page_size: number,
            /**页号*/
            page_no: number
        ];
        recv: {
            /** 总页数 */
            page_total: number;
            /** 页号 */
            page_no: number;
            /** 修改此处要同步修改40061 */
            guild_list: {
                /** 公会id */
                guild_id: number;
                /**  公会名字 */
                guild_name: string;
                /** 公会等级 */
                guild_lv: number;
                /** 公会经验(资金) */
                guild_exp: number;
                /** 会长id */
                chief_id: number;
                /**  会长名字 */
                chief_name: string;
                /** 成员数 */
                member_num: number;
                /** 成员容量 */
                member_capacity: number;
                /** 是否申请 0:无;1:申请 */
                is_apply: number;
                /** 最低战力 */
                auto_approve_power: number;
                /** 公会战力 */
                combat_power: number;
                /** 公会合并状态 0:本公会 1:已请求 2:可合并 3:不可合并 99:无状态(玩家无公会) */
                merge_status: number;
                /** 对本公会来是否主公会 0:没有本公会 1:主公会 2:副公会 */
                is_master: number;
            }[];
        };
    };
    40002: {
        desc: "申请加入公会";
        send: (
            number: 40002,
            fmt: "l",
            args: [
                /**公会id*/
                guild_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**公会id*/
            guild_id: number
        ];
        recv: {
            error_code: number;
            /** 公会id */
            guild_id: number;
            /** 0:无;1:审批中;2:自动加入 */
            apply_type: number;
        };
    };
    40003: {
        desc: "批量申请";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
            /** 公会id 自动加入才有值 其他情况为0 */
            guild_id: number;
            /** 0:无;1:审批中;2:自动加入 */
            apply_type: number;
        };
    };
    40004: {
        desc: "创建公会";
        send: (
            number: 40004,
            fmt: "ls",
            args: [
                /**消耗配置id 1: 非绑定钻石 2: 金币*/
                cfg_id: number,
                /** 公会名字*/
                guild_name: string
            ]
        ) => never;
        sendFmt: "ls";
        sendArgs: [
            /**消耗配置id 1: 非绑定钻石 2: 金币*/
            cfg_id: number,
            /** 公会名字*/
            guild_name: string
        ];
        recv: {
            error_code: number;
            guild_id: number;
        };
    };
    40005: {
        desc: "获取公会信息界面-基础信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 帮派id */
            guild_id: number;
            /**  帮派名字 */
            guild_name: string;
            /**  公会公告 */
            announce: string;
            /** 职位列表 任命了才有数据 如果公会没有会长这个列表为空 */
            position_list: {
                /** 职位 普通成员不会发 */
                position: number;
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
            }[];
            /** 公会等级 */
            guild_lv: number;
            /** 公会资金 */
            gfunds: number;
            /** 公会成长值 */
            growth_val: number;
            /** 公会活跃度 */
            gactivity: number;
            /** 正式成员数 */
            member_num: number;
            /** 正式成员容量 */
            member_capacity: number;
            /** 公会战力 */
            combat_power: number;
            /** 在线人数 */
            online_num: number;
            /** 解散警告时间  没有的话为0 */
            disband_warnning_time: number;
            /** 工资领取状态 0: 未领取 1: 已领取 */
            salary_status: number;
            /** 公会争霸赛区评级 1:S级 2:A级 3:B级 4:C级 其他:无 */
            division: number;
            /** 入会时间戳 */
            join_time: number;
            /** 是否在合并流程中(合并请求已同意但未到合并操作时间) 0:否 1:是 */
            is_in_merge: number;
        };
    };
    40006: {
        desc: "获取公会信息界面-成员列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 成员列表 */
            member_list: {
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
                /** 战力 */
                combat_power: number;
                /** 是否在线 1:在线 0:不在线 */
                online_flag: number;
                /** 离线时间 */
                offline_time: number;
                /** 加入公会时间 */
                create_time: number;
            }[];
        };
    };
    40007: {
        desc: "主动退出公会";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    40008: {
        desc: "申请列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 申请列表 */
            apply_list: {
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
                /** 玩家战力 */
                combat_power: number;
            }[];
        };
    };
    40009: {
        desc: "审批加入公会的玩家";
        send: (
            number: 40009,
            fmt: "lc",
            args: [role_id: number, type: number]
        ) => never;
        sendFmt: "lc";
        sendArgs: [role_id: number, type: number];
        recv: {
            error_code: number;
            type: number;
            role_id: number;
        };
    };
    40010: {
        desc: "审批设置界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 审批设置 */
            approve_type: number;
            /** 最低等级 */
            auto_approve_lv: number;
            /** 最低战力 */
            auto_approve_power: number;
        };
    };
    40011: {
        desc: "设置审批";
        send: (
            number: 40011,
            fmt: "chi",
            args: [
                /**审批设置*/
                approve_type: number,
                /**最低等级*/
                auto_approve_lv: number,
                /**最低战力*/
                auto_approve_power: number
            ]
        ) => never;
        sendFmt: "chi";
        sendArgs: [
            /**审批设置*/
            approve_type: number,
            /**最低等级*/
            auto_approve_lv: number,
            /**最低战力*/
            auto_approve_power: number
        ];
        recv: {
            error_code: number;
        };
    };
    40012: {
        desc: "编辑公告(先用40019协议获取界面信息)";
        send: (
            number: 40012,
            fmt: "cs",
            args: [
                /**1: 保存 2: 保存并通知*/
                save_type: number,
                /** 公告*/
                announce: string
            ]
        ) => never;
        sendFmt: "cs";
        sendArgs: [
            /**1: 保存 2: 保存并通知*/
            save_type: number,
            /** 公告*/
            announce: string
        ];
        recv: {
            error_code: number;
        };
    };
    40013: {
        desc: "任命职位";
        send: (
            number: 40013,
            fmt: "lc",
            args: [
                /**玩家id*/
                role_id: number,
                /**职位*/
                position: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**玩家id*/
            role_id: number,
            /**职位*/
            position: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 玩家id */
            role_id: number;
            /** 职位 */
            position: number;
        };
    };
    40014: {
        desc: "踢出公会";
        send: (
            number: 40014,
            fmt: "l",
            args: [
                /**玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**玩家id*/
            role_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 玩家id */
            role_id: number;
        };
    };
    40015: {
        desc: "玩家的公会信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 公会id */
            guild_id: number;
            /**  公会名字 */
            guild_name: string;
            /** 公会等级 */
            guild_lv: number;
            /** 职位 */
            position: number;
            /**  职位的名字 */
            position_name: string;
        };
    };
    40016: {
        desc: "全部同意/拒绝入会";
        send: (
            number: 40016,
            fmt: "c",
            args: [
                /**1: 同意 2: 拒绝*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1: 同意 2: 拒绝*/
            type: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 1: 同意 2: 拒绝 */
            type: number;
        };
    };
    40017: {
        desc: "广播公会信息到场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 公会id */
            guild_id: number;
            /**  公会名字 */
            guild_name: string;
            /** 职位 */
            position: number;
            /**  职位的名字 */
            position_name: string;
        };
    };
    40018: {
        desc: "提升公会等级";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    40019: {
        desc: "公告编辑界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 剩余修改次数 */
            remain_times: number;
            /** 免费次数 */
            free_times: number;
        };
    };
    40020: {
        desc: "领取工资";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    40021: {
        desc: "玩家拥有的权限列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            permission_type_list: {
                /** 权限 */
                permission_type: number;
            }[];
        };
    };
    40023: {
        desc: "捐献界面列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 公会活跃度 */
            gactivity: number;
            /** 已捐次数 */
            donate_times: number;
            self_gift_list: {
                gift_id: number;
                /** 0 未领取 1 已领取 */
                gift_status: number;
            }[];
            donate_record: {
                donate_id: number;
                role_id: number;
                role_name: string;
                donate_type: number;
                /** 此次捐献次数 */
                times: number;
                /** 增加的贡献 */
                donate_add: number;
                /** 增加的公会资金 */
                gfunds_add: number;
                /** 增加的公会活跃 */
                guild_activity: number;
                /** 捐献时间 */
                time: number;
            }[];
        };
    };
    40024: {
        desc: "玩家捐献";
        send: (
            number: 40024,
            fmt: "cc",
            args: [donate_type: number, times: number]
        ) => never;
        sendFmt: "cc";
        sendArgs: [donate_type: number, times: number];
        recv: {
            error_code: number;
            donate_type: number;
            /** 总共捐献次数 */
            donate_times: number;
            /** 拥有的贡献度 */
            donate: number;
            /** 总贡献 */
            historical_donate: number;
            /** 总资金 */
            gfunds: number;
            /** 公会活跃度 */
            gactivity: number;
        };
    };
    40025: {
        desc: "领取每日礼包";
        send: (
            number: 40025,
            fmt: "h",
            args: [
                /**礼包id*/
                gift_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**礼包id*/
            gift_id: number
        ];
        recv: {
            error_code: number;
            /** 礼包id */
            gift_id: number;
        };
    };
    40026: {
        desc: "玩家捐献记录增加";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            donate_record: {
                donate_id: number;
                role_id: number;
                role_name: string;
                donate_type: number;
                /** 此次捐献次数 */
                times: number;
                /** 增加的个人活跃度 */
                donate_add: number;
                /** 增加的公会资金 */
                gfunds_add: number;
                /** 增加的公会活跃 */
                guild_activity: number;
                /** 捐献时间 */
                time: number;
            }[];
        };
    };
    40027: {
        desc: "会长解散公会";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    40028: {
        desc: "广播公会总活跃度";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 公会活跃度 */
            gactivity: number;
        };
    };
    40029: {
        desc: "调戏入会玩家";
        send: (number: 40029, fmt: "l", args: [role_id: number]) => never;
        sendFmt: "l";
        sendArgs: [role_id: number];
        recv: null;
    };
    40030: {
        desc: "玩家声望信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            all_prestige: number;
            title_id: number;
            /** 本周获取的声望值 */
            prestige_week: number;
            /** 当前获取声望限制（根据职位变动4点刷新） */
            prestige_limit: number;
        };
    };
    40031: {
        desc: "推送玩家今日声望获取情况";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            all_prestige: number;
            /** 今天获取的声望值总值 */
            prestige_day: number;
            /** 今天获取的有限制的声望值总值 */
            prestige_day_limit: number;
        };
    };
    40039: {
        desc: "玩家贡献度推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 公会贡献 */
            donate: number;
        };
    };
    40040: {
        desc: "公会技能列表(已研究的)";
        send: (
            number: 40040,
            fmt: "c",
            args: [
                /**1: 基础技能 2: 高级技能*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1: 基础技能 2: 高级技能*/
            type: number
        ];
        recv: {
            /** 公会贡献 */
            donate: number;
            skill_list: {
                /** 技能id */
                skill_id: number;
                /** 学习等级 */
                learn_lv: number;
                /** 研究等级 */
                research_lv: number;
                /** 当前技能加成战力 */
                cur_power: number;
                /** 升至下一级的加成战力（没有下一级时为0） */
                next_power: number;
            }[];
        };
    };
    40041: {
        desc: "研究公会技能";
        send: (
            number: 40041,
            fmt: "i",
            args: [
                /**技能id*/
                skill_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**技能id*/
            skill_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 技能id */
            skill_id: number;
            /** 研究等级 */
            research_lv: number;
            /** 公会资金 */
            gfunds: number;
        };
    };
    40042: {
        desc: "学习公会技能";
        send: (
            number: 40042,
            fmt: "i",
            args: [
                /**技能id*/
                skill_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**技能id*/
            skill_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 技能id */
            skill_id: number;
            /** 学习等级 */
            learn_lv: number;
            /** 公会贡献 */
            donate: number;
            /** 当前技能加成战力 */
            cur_power: number;
            /** 升至下一级的加成战力（没有下一级时为0） */
            next_power: number;
        };
    };
    40043: {
        desc: "公会改名";
        send: (number: 40043, fmt: "s", args: [new_name: string]) => never;
        sendFmt: "s";
        sendArgs: [new_name: string];
        recv: {
            error_code: number;
            new_name: string;
        };
    };
    40044: {
        desc: "公会改名信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1免费修改 2不能免费 */
            is_free: number;
            /** 下次可改名时间倒计时 */
            next_rename_time: number;
        };
    };
    40050: {
        desc: "获取公会副本界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
            /** 当前层数 */
            level: number;
            /** 公会当前副本积分 */
            dun_score: number;
            /** 剩余挑战次数 */
            challenge_times: number;
            /** 个人积分 */
            role_score: number;
            score_gift_list: {
                gift_id: number;
                /** 0 未领取 1 已领取 2 可领取 */
                gift_status: number;
            }[];
        };
    };
    40051: {
        desc: "领取积分奖励";
        send: (number: 40051, fmt: "h", args: [gift_id: number]) => never;
        sendFmt: "h";
        sendArgs: [gift_id: number];
        recv: {
            code: number;
            gift_id: number;
        };
    };
    40052: {
        desc: "挑战时间戳";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 时间戳 */
            end_time: number;
            /** 挑战类型 */
            type: number;
            /** 怪物或假人id */
            target_id: number;
            /** 假人战力 */
            combat_power: number;
        };
    };
    40053: {
        desc: "挑战";
        send: (
            number: 40053,
            fmt: "c",
            args: [
                /**选择入口*/
                door: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**选择入口*/
            door: number
        ];
        recv: {
            code: number;
            /** 选择入口 */
            door: number;
        };
    };
    40054: {
        desc: "主动离开";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    40055: {
        desc: "结算界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 挑战类型 */
            type: number;
            /** 层数 */
            level: number;
            /** 选择入口 */
            door: number;
            /** 通风报信剩余次数 */
            notify_times: number;
            /** 1 胜利 */
            is_win: number;
            score_add: number;
            reward_list: any;
        };
    };
    40056: {
        desc: "查看成员挑战信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            challenge_list: {
                role_id: number;
                role_name: string;
                level: number;
                /** 个人积分 */
                role_score: number;
            }[];
        };
    };
    40057: {
        desc: "通风报信";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    40058: {
        desc: "通风报信记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            notify_list: {
                id: number;
                role_id: number;
                role_name: string;
                level: number;
                door: number;
                type: number;
                time: number;
            }[];
        };
    };
    40060: {
        desc: "公会求助(boss玩法)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 求助玩家 */
            role_id: number;
            role_name: string;
            role_lv: number;
            role_career: number;
            role_sex: number;
            role_pic: string;
            role_pic_ver: number;
            boss_type: number;
            boss_type_name: string;
            boss_id: number;
            layer: number;
            /** 场景id */
            scene_id: number;
            x: number;
            y: number;
        };
    };
    40061: {
        desc: "请求合并公会列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 修改此处要同步修改40001 */
            guild_list: {
                /** 公会id */
                guild_id: number;
                /**  公会名字 */
                guild_name: string;
                /** 公会等级 */
                guild_lv: number;
                /** 公会经验(资金) */
                guild_exp: number;
                /** 会长id */
                chief_id: number;
                /**  会长名字 */
                chief_name: string;
                /** 成员数 */
                member_num: number;
                /** 成员容量 */
                member_capacity: number;
                /** 是否申请 0:无;1:申请 */
                is_apply: number;
                /** 最低战力 */
                auto_approve_power: number;
                /** 公会战力 */
                combat_power: number;
                /** 公会合并状态 0:本公会 1:已请求 2:可合并 3:不可合并 99:无状态(玩家无公会) */
                merge_status: number;
                /** 对本公会来是否主公会 0:没有本公会 1:主公会 2:副公会 */
                is_master: number;
            }[];
        };
    };
    40062: {
        desc: "申请合并公会";
        send: (
            number: 40062,
            fmt: "l",
            args: [
                /**目标公会id*/
                guild_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**目标公会id*/
            guild_id: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            guild_id: number;
        };
    };
    40063: {
        desc: "同意/拒绝合并公会";
        send: (
            number: 40063,
            fmt: "cl",
            args: [
                /**操作类型 1:同意 2:拒绝*/
                op_type: number,
                /**请求公会id*/
                guild_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**操作类型 1:同意 2:拒绝*/
            op_type: number,
            /**请求公会id*/
            guild_id: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            guild_id: number;
        };
    };
}
