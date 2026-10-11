/** 公会战
 */
declare interface ProtoFmtInfo {
    50500: {
        desc: "红点信息(登陆的时候查)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            red_hot: {
                /** 1 每日福利红点 2 分配奖励红点 */
                key: number;
                /** 0 没有红点 1 有红点 */
                is_show: number;
            }[];
        };
    };
    50501: {
        desc: "活动界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1为可领取；2为不可领取 3 已领取 */
            type: number;
            /** 霸主公会id */
            winner: number;
            /** 会长id */
            chief_id: number;
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
            /** 连胜次数 */
            win_num: number;
            /** 0 无 1 连胜 2 终结 */
            reward_type: number;
            /** 连胜奖励键(即连胜次数) */
            reward_key: number;
            /** 已分配的玩家id */
            reward_owner: number;
        };
    };
    50502: {
        desc: "领取每日奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1为成功 */
            error_code: number;
        };
    };
    50503: {
        desc: "进入退出场景";
        send: (
            number: 50503,
            fmt: "c",
            args: [
                /**1为进入场景；2为退出场景*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1为进入场景；2为退出场景*/
            type: number
        ];
        recv: {
            /** 1为成功 */
            error_code: number;
            /** 请求类型 */
            type: number;
        };
    };
    50504: {
        desc: "活动剩余时间(切进场景是请求)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 结束时间 */
            end_time: number;
        };
    };
    50505: {
        desc: "战场奖励列表(暂时没有阶段奖励，服务端推的是空列表)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            stage_list: {
                /** 奖励阶段id */
                keyid: number;
                /** 需要积分 */
                needscore: number;
                /** 1为未达条件；2为达到条件未领取；3为已领取 */
                state: number;
            }[];
        };
    };
    50506: {
        desc: "战场公会排名(这个榜单不是实时的，即有可能rank值是错的，客户端获取列表后最好自己排序一下)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己的公会id */
            my_guild: number;
            guild_list: {
                /** 公会id */
                guild_id: number;
                /** 排名(活动结束后该值才生效，互动期间可能有误，需客户端去排名) */
                rank: number;
                /** 公会名 */
                guild_name: string;
                /** 积分 */
                score: number;
                /** 第二排序键值 */
                sec_sort_key: number;
                own_list: {
                    /** 占领的据点id */
                    mod_id: number;
                }[];
            }[];
        };
    };
    50507: {
        desc: "战场公会据点";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            own_list: {
                /** 1为未占领；2为已被占领 */
                type: number;
                /** 公会id */
                guild_id: number;
                /** 占领公会名 */
                guild_name: string;
                /** 据点id */
                mon_id: number;
                /** 据点当前血量 */
                hp: number;
                /** 据点上限血量 */
                hp_lim: number;
            }[];
        };
    };
    50508: {
        desc: "据点加积分进入和退出收益范围";
        send: (
            number: 50508,
            fmt: "ic",
            args: [
                /**据点id*/
                mon_id: number,
                /**1为进入；2为退出*/
                type: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**据点id*/
            mon_id: number,
            /**1为进入；2为退出*/
            type: number
        ];
        recv: {
            /** 1为成功 */
            error_code: number;
        };
    };
    50509: {
        desc: "战场领取个人积分奖励";
        send: (
            number: 50509,
            fmt: "c",
            args: [
                /**奖励阶段id*/
                keyid: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**奖励阶段id*/
            keyid: number
        ];
        recv: {
            /** 1为成功 */
            error_code: number;
            /** 奖励阶段id */
            keyid: number;
        };
    };
    50511: {
        desc: "战场结束推送页面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己公会 */
            my_guild: number;
            /** 自己积分 */
            my_score: number;
            /** 自己排名 */
            my_rank: number;
            guild_list: {
                /** 公会id */
                guild_id: number;
                /** 排名 */
                rank: number;
                /** 公会名 */
                guild_name: string;
                /** 积分 */
                score: number;
                /** 第二排序键值 */
                sec_sort_key: number;
                own_list: {
                    /** 占领的据点id */
                    mod_id: number;
                }[];
            }[];
        };
    };
    50512: {
        desc: "战场推送个人积分";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 个人积分 */
            score: number;
            /** 资源点数量 */
            resource: number;
        };
    };
    50513: {
        desc: "据点占领";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 据点id */
            mon_id: number;
            /** 公会id */
            guild_id: number;
        };
    };
    50514: {
        desc: "查看玩家排行榜(客户端自己根据积分和杀人数进行排名)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_list: {
                /** 玩家id */
                role_id: number;
                role_name: string;
                guild_id: number;
                guild_name: string;
                /** 积分 */
                score: number;
                /** 杀人数 */
                kill_num: number;
                /** 个人排名(只有活动结束后，这个值才是有效的，活动期间，客户端自己排序) */
                rank: number;
            }[];
        };
    };
    50516: {
        desc: "自己公会排名和分数(服务端定时推)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己的公会id */
            my_guild: number;
            /** 排名 */
            rank: number;
            /** 积分 */
            score: number;
        };
    };
    50517: {
        desc: "会长召集";
        send: (
            number: 50517,
            fmt: "i",
            args: [
                /**据点id*/
                mon_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**据点id*/
            mon_id: number
        ];
        recv: {
            /** 据点id */
            mon_id: number;
        };
    };
    50518: {
        desc: "分配奖励";
        send: (
            number: 50518,
            fmt: "l",
            args: [
                /**分配奖励给玩家*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**分配奖励给玩家*/
            role_id: number
        ];
        recv: {
            code: number;
        };
    };
    50519: {
        desc: "连杀数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_id: number;
            role_name: string;
            /** 性别 */
            sex: number;
            /** 阵营 */
            realm: number;
            /** 职业 */
            career: number;
            /** 等级 */
            lv: number;
            /**  头像地址 */
            picture: string;
            /** 头像版本号 */
            picture_ver: number;
            /** 连杀数 */
            ckill_num: number;
        };
    };
    50520: {
        desc: "活动开启状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 未开启 1 开启 */
            war_state: number;
        };
    };
}
