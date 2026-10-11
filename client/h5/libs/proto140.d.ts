/** 关系信息
 */
declare interface ProtoFmtInfo {
    14000: {
        desc: "获取关系列表";
        send: (
            number: 14000,
            fmt: "c",
            args: [
                /**1: 好友 2: 仇人 3: 黑名单*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1: 好友 2: 仇人 3: 黑名单*/
            type: number
        ];
        recv: {
            /** 1: 好友 2: 仇人 3: 黑名单 */
            type: number;
            rela_list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生次数 */
                turn: number;
                /** 等级 */
                lv: number;
                /** vip等级 */
                vip: number;
                /**  玩家上传的头像地址 */
                picture: string;
                /** 玩家上传的头像版本号 */
                picture_ver: number;
                /** 战力 */
                combat_power: number;
                /** 0: 不在线 1: 在线 */
                online_flag: number;
                /** 亲密度 */
                intimacy: number;
                /** 0单身 1情侣 2结婚 */
                marriage_type: number;
                /** 小区id */
                block_id: number;
                /** 房子id */
                house_id: number;
                /** 房子等级 */
                house_lv: number;
                /** 是否有至尊vip标识 */
                is_supvip: number;
                /** 最后聊天时间 */
                last_chat_time: number;
                /** 离线时间 */
                offline_time: number;
                /** 添加时间 */
                add_time: number;
            }[];
        };
    };
    14001: {
        desc: "获取好友推荐";
        send: (
            number: 14001,
            fmt: "c",
            args: [
                /**0: 默认 1: 手动刷新*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0: 默认 1: 手动刷新*/
            type: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            recommended_list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生次数 */
                turn: number;
                /** 等级 */
                lv: number;
                /** vip等级 */
                vip: number;
                /**  玩家上传的头像地址 */
                picture: string;
                /** 玩家上传的头像版本号 */
                picture_ver: number;
                /** 战力值 */
                combat_power: number;
                /** 0: 不在线 1: 在线 */
                online_flag: number;
                /** 0:无 1:有 */
                is_supvip: number;
            }[];
        };
    };
    14002: {
        desc: "通过玩家昵称查找玩家";
        send: (
            number: 14002,
            fmt: "s",
            args: [
                /** 玩家名字*/
                role_name: string
            ]
        ) => never;
        sendFmt: "s";
        sendArgs: [
            /** 玩家名字*/
            role_name: string
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 玩家id */
            role_id: number;
            /**  玩家名字 */
            role_name: string;
            /** 职业 */
            career: number;
            /** 性别 */
            sex: number;
            /** 转生次数 */
            turn: number;
            /** 等级 */
            lv: number;
            /** vip等级 */
            vip: number;
            /**  玩家上传的头像地址 */
            picture: string;
            /** 玩家上传的头像版本号 */
            picture_ver: number;
            /** 战力值 */
            combat_power: number;
            /** 0: 不在线 1: 在线 */
            online_flag: number;
        };
    };
    14003: {
        desc: "发送好友申请";
        send: (
            number: 14003,
            fmt: "l",
            args: [
                /**被请求的玩家id*/
                be_ask_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**被请求的玩家id*/
            be_ask_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    14004: {
        desc: "批量回应添加好友请求";
        send: (
            number: 14004,
            fmt: "c",
            args: [
                /**0:拒绝 1:接受*/
                response_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0:拒绝 1:接受*/
            response_type: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    14005: {
        desc: "回应单个添加好友请求";
        send: (
            number: 14005,
            fmt: "lc",
            args: [
                /**请求者id*/
                ask_id: number,
                /**0:拒绝 1:接受 2:拉黑*/
                response_type: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**请求者id*/
            ask_id: number,
            /**0:拒绝 1:接受 2:拉黑*/
            response_type: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    14006: {
        desc: "获取好友请求列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            ask_list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 职业 */
                career: number;
                /** 转生次数 */
                turn: number;
                /** 等级 */
                lv: number;
                /**  玩家上传的头像地址 */
                picture: string;
                /** 玩家上传的头像版本号 */
                picture_ver: number;
                /** 战力 */
                combat_power: number;
                /** 请求添加时间 */
                add_time: number;
            }[];
        };
    };
    14007: {
        desc: "好友操作";
        send: (
            number: 14007,
            fmt: "cl",
            args: [
                /**1:删除好友 2:拉黑 3:取消拉黑 4:添加仇人 5:移除仇人*/
                type: number,
                /**玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**1:删除好友 2:拉黑 3:取消拉黑 4:添加仇人 5:移除仇人*/
            type: number,
            /**玩家id*/
            role_id: number
        ];
        recv: {
            code: number;
        };
    };
    14008: {
        desc: "新的好友请求";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /**  玩家名字 */
            role_name: string;
            /** 职业 */
            career: number;
            /** 转生次数 */
            turn: number;
            /** 等级 */
            lv: number;
            /**  玩家上传的头像地址 */
            picture: string;
            /** 玩家上传的头像版本号 */
            picture_ver: number;
            /** 战力 */
            combat_power: number;
            /** 请求添加时间 */
            add_time: number;
        };
    };
    14009: {
        desc: "上下线通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /**  玩家名字 */
            role_name: string;
            /** 1: 好友 2: 仇人 */
            rela_type: number;
            /** 0: 下线 1: 上线 */
            online_flag: number;
            /** 当前时间戳 */
            timestamp: number;
        };
    };
    14010: {
        desc: "获取玩家交互菜单信息";
        send: (
            number: 14010,
            fmt: "l",
            args: [
                /**对方玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**对方玩家id*/
            role_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 对方玩家id */
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
            /** 关系 0: 没有关系 1:好友 2:仇人 3:黑名单 4:仇人且黑名单 5:仇人且好友 */
            rela: number;
            /** 队伍id */
            team_id: number;
        };
    };
    14011: {
        desc: "获取玩家对应的社交关系";
        send: (
            number: 14011,
            fmt: "l",
            args: [
                /**对方玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**对方玩家id*/
            role_id: number
        ];
        recv: {
            /** 对方玩家id */
            role_id: number;
            /** 关系 0: 没有关系 1:好友 2:仇人 3:黑名单 4:仇人且黑名单 5:仇人且好友 */
            rela: number;
        };
    };
    14013: {
        desc: "社交关系更新(增加或者更新)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            update_list: {
                /** 1: 好友 2: 仇人 3: 黑名单 */
                type: number;
                /** 需要更新的玩家列表 */
                role_list: {
                    /** 玩家id */
                    role_id: number;
                    /**  玩家名字 */
                    role_name: string;
                    /** 职业 */
                    career: number;
                    /** 性别 */
                    sex: number;
                    /** 转生次数 */
                    turn: number;
                    /** 等级 */
                    lv: number;
                    /** vip等级 */
                    vip: number;
                    /**  玩家上传的头像地址 */
                    picture: string;
                    /** 玩家上传的头像版本号 */
                    picture_ver: number;
                    /** 战力 */
                    combat_power: number;
                    /** 0: 不在线 1: 在线 */
                    online_flag: number;
                    /** 亲密度 */
                    intimacy: number;
                    /** 0单身 1情侣 2结婚 */
                    marriage_type: number;
                    /** 小区id */
                    block_id: number;
                    /** 房子id */
                    house_id: number;
                    /** 房子等级 */
                    house_lv: number;
                    /** 是否有至尊vip标识 */
                    is_supvip: number;
                    /** 最后聊天时间 */
                    last_chat_time: number;
                    /** 离线时间 */
                    offline_time: number;
                    /** 添加时间 */
                    add_time: number;
                }[];
            }[];
        };
    };
    14014: {
        desc: "社交关系更新(移除)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            update_list: {
                /** 1: 好友 2: 仇人 3: 黑名单 */
                type: number;
                /** 需要更新的玩家id列表 */
                role_ids: {
                    /** 玩家id */
                    role_id: number;
                }[];
            }[];
        };
    };
    14015: {
        desc: "亲密度更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 亲密度 */
            intimacy: number;
        };
    };
    14016: {
        desc: "劲敌模块界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            enermy_list: {
                /** 劲敌id */
                enermy_role_id: number;
                /**  劲敌名称 */
                enermy_role_name: string;
                /** 冲突值（被击杀次数） */
                be_killed_count: number;
            }[];
        };
    };
    14017: {
        desc: "劲敌模块被击杀记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            be_killed_list: {
                /** 时间 */
                time: number;
                /** 地点（场景名） */
                scene_name: string;
                /** 击杀者服务器id */
                server_id: number;
                /** 击杀者服务器数量 */
                server_num: number;
                /** 击杀者名字 */
                attr_name: string;
                /** 击杀者id */
                attr_id: number;
            }[];
        };
    };
    14099: {
        desc: "通用错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
}
