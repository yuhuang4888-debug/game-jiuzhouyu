/** 决斗场
 */
declare interface ProtoFmtInfo {
    65300: {
        desc: "决斗场状态(状态变更时会推送)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 状态 0未开放 1开放期间 */
            state: number;
            /** 剩余时间 */
            left_time: number;
        };
    };
    65301: {
        desc: "获取玩家信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 排名 */
            rank: number;
            /** 战力 */
            combat: number;
            /** 积分 */
            score: number;
            /** 领取阶段奖励列表 */
            stage_reward: {
                /** 领取状态 */
                state: number;
                /** 阶段 */
                stage: number;
            }[];
        };
    };
    65302: {
        desc: "挑战次数信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
            /** 剩余挑战次数 */
            left_num: number;
            /** 次数刷新时间戳(根据挑战次数和刷新时间戳算出真正的挑战次数) */
            num_refresh: number;
            /** 总购买次数 */
            buy_num: number;
            /** 可购买次数 */
            can_buy_num: number;
        };
    };
    65303: {
        desc: "随机对手";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_list: {
                /** 玩家ID */
                role_id: number;
                /** 挑战成功获得的积分 */
                score: number;
                /** 声望 */
                honor: number;
                /** 战力 */
                combat: number;
                /** 血量 */
                hp: number;
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
            }[];
        };
    };
    65304: {
        desc: "战斗假人信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己假人id */
            self_robot_id: number;
            /** 对手假人id */
            rival_robot_id: number;
        };
    };
    65305: {
        desc: "挑战对手";
        send: (
            number: 65305,
            fmt: "llc",
            args: [
                /**对手ID*/
                rival_id: number,
                /**战力*/
                combat: number,
                /**0 : 进场景打 1：直接击败*/
                challenge_type: number
            ]
        ) => never;
        sendFmt: "llc";
        sendArgs: [
            /**对手ID*/
            rival_id: number,
            /**战力*/
            combat: number,
            /**0 : 进场景打 1：直接击败*/
            challenge_type: number
        ];
        recv: {
            /** 挑战结果 1:胜利 0：失败 */
            result: number;
            /** 奖励列表 */
            reward_list: {
                /** 奖励类型 */
                type: number;
                /** 类型Id */
                type_id: number;
                /** 奖励数目 */
                num: number;
            }[];
        };
    };
    65306: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
        };
    };
    65307: {
        desc: "领取奖励";
        send: (
            number: 65307,
            fmt: "h",
            args: [
                /**领取的档次*/
                stage: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**领取的档次*/
            stage: number
        ];
        recv: {
            /** 领取的档次 */
            stage: number;
            /** 错误码  1成功 */
            errcode: number;
        };
    };
    65308: {
        desc: "购买挑战次数";
        send: (
            number: 65308,
            fmt: "h",
            args: [
                /**购买次數*/
                num: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**购买次數*/
            num: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    65309: {
        desc: "战斗时间信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0等待 1战斗 2结算 */
            stage: number;
            /** 结束时间戳 */
            time: number;
        };
    };
    65310: {
        desc: "排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            info_list: {
                /** 排名 */
                rank: number;
                /** 玩家id */
                role_id: number;
                /**  名字 */
                role_name: string;
                /** 积分 */
                score: number;
                /** 服务器ID */
                server_id: number;
            }[];
        };
    };
    65311: {
        desc: "跳过战斗";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 成功 */
            errcode: number;
        };
    };
    65399: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
}
