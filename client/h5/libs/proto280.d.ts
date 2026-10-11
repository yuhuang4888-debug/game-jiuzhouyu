/** 竞技场信息
 */
declare interface ProtoFmtInfo {
    28000: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    28001: {
        desc: "获取玩家jjc信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 排名 */
            rank: number;
            /** 历史最高排名 */
            history_rank: number;
            /** 奖励根据的排名 */
            reward_rank: number;
            /** 战力 */
            combat: number;
            /** 血量 */
            hp: number;
            /** 挑战次数 */
            num: number;
            /** 次数刷新时间戳(根据挑战次数和刷新时间戳算出真正的挑战次数) */
            num_refresh: number;
            /** 荣耀点 */
            honour: number;
            /** 能否领取奖励 */
            is_reward: number;
            /** 宠物Id */
            pet_id: number;
            /** 突破奖励领取列表 */
            break_id_list: {
                /** 突破奖励编号 */
                break_id: number;
            }[];
        };
    };
    28002: {
        desc: "%%随机对手";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_list: {
                /** 排名 */
                rank: number;
                /** 玩家ID */
                role_id: number;
                /** 战力 */
                combat: number;
                /** 血量 */
                hp: number;
                /** 宠物Id */
                pet_id: number;
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
    28003: {
        desc: "挑战对手";
        send: (
            number: 28003,
            fmt: "ilic",
            args: [
                /**自身排名*/
                self_rank: number,
                /**对手ID*/
                rival_id: number,
                /**对手排名*/
                rival_rank: number,
                /**0 : 进场景打 1：直接击败*/
                challenge_type: number
            ]
        ) => never;
        sendFmt: "ilic";
        sendArgs: [
            /**自身排名*/
            self_rank: number,
            /**对手ID*/
            rival_id: number,
            /**对手排名*/
            rival_rank: number,
            /**0 : 进场景打 1：直接击败*/
            challenge_type: number
        ];
        recv: {
            role_list: {
                /** 玩家id */
                role_id: number;
                figure: any;
                /** 玩家之前排名 */
                before_rank: number;
                /** 之后排名 */
                rank: number;
                /** 战力 */
                combat: number;
            }[];
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
            break_reward_list: any;
        };
    };
    28004: {
        desc: "挑战次数信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
            /** 挑战次数 */
            left_num: number;
            /** 次数刷新时间戳(根据挑战次数和刷新时间戳算出真正的挑战次数) */
            num_refresh: number;
            /** 可购买次数 */
            can_buy_num: number;
        };
    };
    28005: {
        desc: "购买挑战次数";
        send: (number: 28005, fmt: "h", args: [num: number]) => never;
        sendFmt: "h";
        sendArgs: [num: number];
        recv: {
            /** 1 成功 */
            errcode: number;
        };
    };
    28006: {
        desc: "战力鼓舞信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
            /** 鼓舞次数 */
            num: number;
        };
    };
    28007: {
        desc: "战力鼓舞";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
            /** 战力 */
            combat: number;
        };
    };
    28008: {
        desc: "领取奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
            /** 能否领取状态 1:能 0:不能 */
            is_reward: number;
            /** 奖励列表 */
            reward_list: {
                /** 奖励类型 */
                type: number;
                /** 类型Id */
                type_id: number;
                /** 奖励数量 */
                num: number;
            }[];
        };
    };
    28009: {
        desc: "被挑战记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
            /** 被挑战记录列表 */
            record_list: {
                /** 挑战玩家id */
                role_id: number;
                /**  玩家上传的头像地址 */
                picture: string;
                /** 玩家上传的头像版本号 */
                picture_ver: number;
                /**  挑战玩家名字 */
                name: string;
                /** 挑战玩家职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生 */
                turn: number;
                /** vip等级 */
                vip_lv: number;
                /** 玩家等级 */
                lv: number;
                /** 战力 */
                combat_power: number;
                /** 胜负 1:胜利 0：失败 */
                result: number;
                /** 0：持平 1：上升 2：下降 */
                state: number;
                /** 变化数值 */
                rank_range: number;
                /** 时间戳 */
                time: number;
            }[];
        };
    };
    28010: {
        desc: "荣誉值";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
            /** 荣誉值 */
            honour: number;
        };
    };
    28011: {
        desc: "王者榜信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
            info_list: {
                rank: number;
                role_id: number;
                combat: number;
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
    28012: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
        };
    };
    28013: {
        desc: "战斗假人信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己假人id */
            self_robot_id: number;
            /** 自己玩家id */
            self_role_id: number;
            /** 对手假人id */
            rival_robot_id: number;
            /** 对手玩家id */
            rival_role_id: number;
        };
    };
    28014: {
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
    28015: {
        desc: "跳过战斗";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
        };
    };
    28016: {
        desc: "被挑战单挑记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 挑战玩家id */
            role_id: number;
            /**  玩家上传的头像地址 */
            picture: string;
            /** 玩家上传的头像版本号 */
            picture_ver: number;
            /**  挑战玩家名字 */
            name: string;
            /** 挑战玩家职业 */
            career: number;
            /** 性别 */
            sex: number;
            /** 转生 */
            turn: number;
            /** vip等级 */
            vip_lv: number;
            /** 玩家等级 */
            lv: number;
            /** 战力 */
            combat_power: number;
            /** 胜负 1:胜利 0：失败 */
            result: number;
            /** 0：持平 1：上升 2：下降 */
            state: number;
            /** 变化数值 */
            rank_range: number;
            /** 时间戳 */
            time: number;
        };
    };
    28017: {
        desc: "领取突破奖励";
        send: (
            number: 28017,
            fmt: "i",
            args: [
                /**突破奖励编号*/
                break_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**突破奖励编号*/
            break_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 突破奖励编号 */
            break_id: number;
            reward: any;
        };
    };
    28018: {
        desc: "战斗loading结束发送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
}
