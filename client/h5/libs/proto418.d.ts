/** 魅力海滩
 */
declare interface ProtoFmtInfo {
    41800: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            res: number;
        };
    };
    41801: {
        desc: "活动状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动状态 */
            status: number;
            /** 开始时间 */
            start_time: number;
            /** 活动持续时长（秒） */
            duration: number;
        };
    };
    41802: {
        desc: "进入场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            rcode: number;
        };
    };
    41803: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            rcode: number;
        };
    };
    41804: {
        desc: "个人信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 排名 0-未上榜 */
            rank: number;
            /** 当前累积经验 */
            acc_exp: number;
            /** 魅力值 */
            charm_v: number;
            /** 剩余赠送次数 */
            gift_times: number;
        };
    };
    41805: {
        desc: "魅力排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自身魅力值 */
            self_charmv: number;
            /** 玩家数据 */
            rank_list: {
                /** 排名 */
                rank: number;
                /** 玩家id */
                role_id: number;
                /**  玩家头像 */
                picture: string;
                /** 玩家区服 */
                server_id: number;
                /**  玩家名字 */
                name: string;
                /** 公会id 8278 */
                guild_id: number;
                /**  公会名字 */
                guild_name: string;
                /** 魅力值 */
                charm_v: number;
                /** 职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生数 */
                turn: number;
            }[];
        };
    };
    41806: {
        desc: "赠送礼物赠送成功对方收到41815";
        send: (
            number: 41806,
            fmt: "lc",
            args: [
                /**被赠送玩家id*/
                role_id: number,
                /**赠送物品*/
                gift_id: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**被赠送玩家id*/
            role_id: number,
            /**赠送物品*/
            gift_id: number
        ];
        recv: {
            /** 返回码 */
            rcode: number;
        };
    };
    41807: {
        desc: "获取约会玩家信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            valid_list: {
                /** 玩家id */
                role_id: number;
                /** 魅力值 */
                charm_v: number;
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
    41808: {
        desc: "发起邀请约会发送成功了对方会收到41809";
        send: (number: 41808, fmt: any, args: [ask_list: any]) => never;
        sendFmt: any;
        sendArgs: [ask_list: any];
        recv: {
            /** 返回码 */
            rcode: number;
        };
    };
    41809: {
        desc: "约会邀请信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /**  玩家名字 */
            name: string;
        };
    };
    41810: {
        desc: "约会回复消息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /**  玩家名字 */
            name: string;
            /** 0-拒绝 1-同意 */
            res: number;
        };
    };
    41811: {
        desc: "回复邀请约会请求回复后对方会收到41810";
        send: (
            number: 41811,
            fmt: "lc",
            args: [
                /**发起约会的玩家id*/
                role_id: number,
                /**是否答应赴约 0-拒绝 1-同意*/
                req: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**发起约会的玩家id*/
            role_id: number,
            /**是否答应赴约 0-拒绝 1-同意*/
            req: number
        ];
        recv: {
            /** 返回码 */
            rcode: number;
            /** 发起约会的玩家id */
            role_id: number;
            /** 是否答应赴约 0-拒绝 1-同意 2-已经邀请过 */
            req: number;
        };
    };
    41812: {
        desc: "终止约会注：终止成功则会给双方发送41812返回码否则只对发起方返回错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 1-终止成功 */
            res: number;
        };
    };
    41813: {
        desc: "礼物记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            pres_list: {
                /** 赠送玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 赠送次数 */
                times: number;
                /** 操作 0-赠送 1-收到 */
                opera: number;
            }[];
        };
    };
    41814: {
        desc: "购买赠送次数注：成功则推41804";
        send: (
            number: 41814,
            fmt: "h",
            args: [
                /**购买数量*/
                num: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**购买数量*/
            num: number
        ];
        recv: {
            /** 返回码 */
            rcode: number;
            /** 剩余赠送次数 */
            gift_times: number;
        };
    };
    41815: {
        desc: "收到赠送消息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 赠送玩家id */
            role_id: number;
            /** 接收玩家id */
            opp_roleid: number;
            /**  玩家名字 */
            name: string;
            /** 魅力道具id */
            gift_id: number;
        };
    };
    41816: {
        desc: "增加经验注：由客户端触发服务端不会自动触发";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            rcode: number;
            /** 约会增加的经验 */
            engage_exp: number;
        };
    };
    41817: {
        desc: "发放奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 排名 */
            rank: number;
            /** 活动中总经验值 */
            acc_exp: number;
            /** 最终奖励 */
            reward: {
                /** 物品类型 */
                type: number;
                /** 物品id */
                goods_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    41818: {
        desc: "魅力第一";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /**  名字 空字符串表示没有第一名 */
            name: string;
            /** 强制退出时间戳 */
            end_time: number;
        };
    };
    41819: {
        desc: "送礼列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家数据 */
            role_list: {
                /** 玩家id */
                role_id: number;
                /** 玩家区服 */
                server_id: number;
                /**  玩家名字 */
                name: string;
                /** 职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生数 */
                turn: number;
                /**  玩家头像 */
                picture: string;
                /** 魅力值 */
                charm_v: number;
            }[];
        };
    };
    41820: {
        desc: "开始约会";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            x: number;
            y: number;
        };
    };
}
