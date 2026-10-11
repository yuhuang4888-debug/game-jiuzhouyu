/** 圣者殿
 */
declare interface ProtoFmtInfo {
    60700: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /**  参数 */
            args: string;
        };
    };
    60701: {
        desc: "主界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 跨服中心连接状态 */
            link_state: number;
            stone_list: {
                /** 石像id */
                stone_id: number;
                /** 挑战冷却(时间戳) */
                cd: number;
                /** 挑战中状态 */
                status: number;
                /** 玩家ID 为0是石像 不为0为玩家 */
                role_id: number;
                /**  玩家服务器名 */
                server_name: string;
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
                combat: number;
            }[];
        };
    };
    60702: {
        desc: "进入圣者殿大厅";
        send: (
            number: 60702,
            fmt: "i",
            args: [
                /**石像id*/
                stone_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**石像id*/
            stone_id: number
        ];
        recv: {
            /** 石像id */
            stone_id: number;
        };
    };
    60703: {
        desc: "挑战次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 剩余挑战次数 */
            count: number;
            /** 总挑战次数 */
            max_count: number;
        };
    };
    60704: {
        desc: "挑战";
        send: (
            number: 60704,
            fmt: "i",
            args: [
                /**石像id*/
                stone_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**石像id*/
            stone_id: number
        ];
        recv: {
            /** 石像id */
            stone_id: number;
            /** 转盘属性配置id */
            attr_id: number;
        };
    };
    60705: {
        desc: "我要属性";
        send: (
            number: 60705,
            fmt: "c",
            args: [
                /**是否要转盘属性*/
                is_want: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**是否要转盘属性*/
            is_want: number
        ];
        recv: {
            is_want: number;
        };
    };
    60706: {
        desc: "战斗场景信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 转盘属性id */
            turn_id: number;
            inspire_list: {
                /** 鼓舞id */
                inspire_id: number;
                /** 鼓舞次数 */
                inspire_num: number;
                /** 剩余时间戳 */
                inspire_time: number;
            }[];
            /** 战斗结束时间戳 */
            end_time: number;
        };
    };
    60707: {
        desc: "鼓舞";
        send: (
            number: 60707,
            fmt: "i",
            args: [
                /**鼓舞id*/
                inspire_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**鼓舞id*/
            inspire_id: number
        ];
        recv: {
            /** 鼓舞id */
            inspire_id: number;
            /** 鼓舞次数 */
            inspire_num: number;
            /** 剩余时间戳 */
            inspire_time: number;
        };
    };
    60708: {
        desc: "退出圣者殿大厅";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    60709: {
        desc: "退出挑战场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    60710: {
        desc: "挑战结果信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            is_success: number;
            /** 奖励列表 */
            reward_list: {
                /** 物品类型 */
                type: number;
                /** 物品类型Id */
                type_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    60711: {
        desc: "挑战记录";
        send: (
            number: 60711,
            fmt: "i",
            args: [
                /**石像id*/
                stone_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**石像id*/
            stone_id: number
        ];
        recv: {
            /** 石像id */
            stone_id: number;
            record_list: {
                /** 时间 */
                time: number;
                /** 玩家Id */
                role_id: number;
                /**  服务器名 */
                server_name: string;
                /**  玩家名字 */
                role_name: string;
                /** 1:成功 0:失败 */
                res: number;
            }[];
        };
    };
}
