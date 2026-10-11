/** 公会活动
 */
declare interface ProtoFmtInfo {
    40200: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    40201: {
        desc: "公会Boss信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动结束时间 >0 表示已经开启 */
            etime: number;
            /** 自动召唤时间戳 */
            auto_drumup_time: number;
            /** 副本Id */
            dun_id: number;
            /** 兽粮 */
            gboss_mat: number;
            /** 剩余开启次数 */
            remain_times: number;
            is_auto: number;
            /** 1 今天已召集过 */
            is_drum_today: number;
            /** 1 boss存在 2 boss死亡 */
            mon_state: number;
        };
    };
    40203: {
        desc: "开启公会Boss获得兽粮";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 增加值 */
            add_gboss_mat: number;
            /** 公会总兽粮 */
            gboss_mat: number;
        };
    };
    40204: {
        desc: "召集";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 召唤boss成功 2 boss被击杀 其他：配置的错误码 */
            errcode: number;
            /** 发起召集的玩家id */
            role_id: number;
        };
    };
    40208: {
        desc: "进入公会Boss副本获取下次召集时间客户端自行判断会长进副本才请求离开公会boss挑战结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 失败 1 成功 */
            gboss_result: number;
            fix_reward: {
                /** 类型 */
                gtype: number;
                /** 物品id */
                gtype_id: number;
                /** 数量 */
                gnum: number;
            }[];
            auction_reward: {
                /** 类型 */
                gtype: number;
                /** 物品id */
                gtype_id: number;
                /** 数量 */
                gnum: number;
            }[];
        };
    };
    40209: {
        desc: "设置自动召唤";
        send: (number: 40209, fmt: "c", args: [is_auto: number]) => never;
        sendFmt: "c";
        sendArgs: [is_auto: number];
        recv: {
            /** 错误码 */
            errcode: number;
            is_auto: number;
        };
    };
    40210: {
        desc: "采集宝箱所得";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 奖励列表 */
            reward_list: any;
        };
    };
    40211: {
        desc: "公会晚宴信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0: 活动未开启 1: 活动已开启 */
            status: number;
            /** 活动结束时间 */
            act_end_time: number;
            /** 阶段结束时间 */
            etime: number;
            /** 阶段 0:未开启， 1，篝火，2：篝火到答题等待， 3：答题， 4：答题到巨龙准备，5 巨龙阶段 */
            stage: number;
        };
    };
    40212: {
        desc: "进入晚宴场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    40213: {
        desc: "个人奖励信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 累计获得经验 */
            exp: number;
            /** 累计获得贡献 */
            donate: number;
        };
    };
    40214: {
        desc: "积分排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 不是跨服   1 是跨服 */
            is_kf: number;
            guild_list: {
                /** 公会id */
                guild_id: number;
                /** server_num */
                server_num: number;
                /** 公会名字 */
                guild_name: string;
                /** 公会积分 */
                guild_score: number;
                /** 排名 */
                guild_rank: number;
            }[];
            rank_list: {
                /** 排名 */
                rank: number;
                /**  玩家名字 */
                name: string;
                /** 积分 */
                score: number;
            }[];
        };
    };
    40215: {
        desc: "采集宴席奖励（废除）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    40216: {
        desc: "累积经验/贡献（废除）";
        send: (
            number: 40216,
            fmt: "c",
            args: [
                /**1: 经验 2: 贡献*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1: 经验 2: 贡献*/
            type: number
        ];
        recv: null;
    };
    40217: {
        desc: "宴会答题信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0: 未开启 1: 答题中 2: 出题中 */
            status: number;
            /** 本题结束时间 */
            etime: number;
            /** 题目号码 */
            no: number;
            /** 题目id */
            id: number;
        };
    };
    40218: {
        desc: "退出晚宴场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    40219: {
        desc: "是否能采集宴席奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1: 可以 */
            errcode: number;
        };
    };
    40230: {
        desc: "进入守卫公会";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1: 可以 */
            errcode: number;
        };
    };
    40231: {
        desc: "守卫工会状态信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0未开启 1开启 */
            state: number;
            /** 下次状态变更时间 */
            end_time: number;
            /** 自己公会的副本是否已结束 */
            is_end: number;
        };
    };
    40232: {
        desc: "守卫工会当前波数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            wave_num: number;
        };
    };
    40240: {
        desc: "公会争霸活动信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0:活动未开启 1:活动信息确认阶段(客户端当初活动未开启处理) 2:对战阶段 3:停战休息阶段 */
            status: number;
            /** 比赛举办次数 0:表示首届比赛 */
            game_times: number;
            /** 回合数 对战阶段才需要用到 */
            round: number;
            /** 当前阶段结束时间戳 */
            etime: number;
        };
    };
    40241: {
        desc: "公会争霸首届界面信息(未开启)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 公会id */
                guild_id: number;
                /**  公会名字 */
                guild_name: string;
                /** 公会排名 */
                ranking: number;
            }[];
        };
    };
    40242: {
        desc: "公会争霸首届界面信息(开启)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** A方公会id */
                a_guild_id: number;
                /**  A方公会名字 */
                a_gname: string;
                /** B方公会id */
                b_guild_id: number;
                /**  B方公会名字 */
                b_gname: string;
                /** 胜利的公会id 0:表示还在进行中未出结果 */
                victory_id: number;
            }[];
        };
    };
    40243: {
        desc: "公会争霸界面信息(未开启)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 赛区级别 */
                division: number;
                guild_list: {
                    /** 公会id */
                    guild_id: number;
                    /**  公会名字 */
                    guild_name: string;
                    /** 公会排名 */
                    ranking: number;
                }[];
            }[];
        };
    };
    40244: {
        desc: "公会争霸界面信息(已开启)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 赛区级别 */
                division: number;
                guild_list: {
                    /** A方公会id */
                    a_guild_id: number;
                    /**  A方公会名字 */
                    a_gname: string;
                    /** B方公会id */
                    b_guild_id: number;
                    /**  B方公会名字 */
                    b_gname: string;
                    /** 胜利的公会id 0:表示还在进行中未出结果 */
                    victory_id: number;
                }[];
            }[];
        };
    };
    40245: {
        desc: "进入公会争霸";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    40246: {
        desc: "退出公会争霸";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    40247: {
        desc: "公会争霸战斗信息(进入场景后客户端自行请求)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 开始战斗的时间戳 大于这个时间戳则不用显示多少秒后开始战斗这个倒计时 */
            start_pk_time: number;
            list: {
                /** 公会id */
                guild_id: number;
                /** 分组 1: 红 2: 蓝 */
                group_id: number;
                /** 参加公会战的成员数量 */
                member_num: number;
                /** 资源数量 */
                resource: number;
                /** 占领资源点数量 */
                resource_point: number;
                /** 资源增长速率 */
                plus_rate: number;
            }[];
        };
    };
    40248: {
        desc: "战斗信息更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 公会id */
            guild_id: number;
            list: {
                /** 键 1: 参战人数 2: 占领资源点 3: 资源增长速率 4: 资源数量 */
                key: number;
                /** 值 */
                val: number;
            }[];
        };
    };
    40249: {
        desc: "战斗结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1: 胜利 2: 失败 */
            result: number;
            /** 经验奖励 */
            exp: number;
            /** 公会贡献奖励 */
            donate: number;
            reward: {
                /** 物品类型 */
                object_type: number;
                /** 物品类型id */
                gtype_id: number;
                /** 奖励数量 */
                num: number;
            }[];
        };
    };
    40250: {
        desc: "主宰公会界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 主宰公会id */
            guild_id: number;
            /**  主宰公会名字 */
            guild_name: string;
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
            streak_times: number;
            /** 0:不能领取 1:可以领取 2:已领取 */
            salary_status: number;
        };
    };
    40251: {
        desc: "连胜奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 主宰公会id */
            guild_id: number;
            /** 最大连胜次数 */
            max_streak_times: number;
            reward_list: {
                /** 当前档次奖励所需连胜次数 */
                streak_times: number;
                rewards: {
                    /** 物品类型 */
                    object_type: number;
                    /** 物品类型id */
                    gtype_id: number;
                    /** 奖励数量 */
                    num: number;
                }[];
            }[];
            not_allot_list: {
                /** 奖励id */
                id: number;
                /** 物品类型 */
                object_type: number;
                /** 物品类型id 物品类型id相同的客户端自行把奖励进行合并 */
                gtype_id: number;
                /** 奖励数量 */
                num: number;
            }[];
        };
    };
    40252: {
        desc: "终结奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 主宰公会id */
            guild_id: number;
            /** 分配状态 0: 未分配 1: 已分配 */
            allot_status: number;
            /** 已获得奖励  为空表示未激活奖励 */
            obtain_rewards: {
                /** 物品类型 */
                object_type: number;
                /** 物品类型id */
                gtype_id: number;
                /** 奖励数量 */
                num: number;
            }[];
            /** 预览奖励 */
            preview_rewards: {
                /** 物品类型 */
                object_type: number;
                /** 物品类型id */
                gtype_id: number;
                /** 奖励数量 */
                num: number;
            }[];
        };
    };
    40253: {
        desc: "分配奖励";
        send: (
            number: 40253,
            fmt: "clA",
            args: [
                /**1: 连胜奖励 2: 终结奖励*/
                type: number,
                /**分配给的玩家id*/
                specify_id: number,
                /**分配终结奖励时此列表传空列表*/
                list: any
            ]
        ) => never;
        sendFmt: "clA";
        sendArgs: [
            /**1: 连胜奖励 2: 终结奖励*/
            type: number,
            /**分配给的玩家id*/
            specify_id: number,
            /**分配终结奖励时此列表传空列表*/
            list: any
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 1: 连胜奖励 2: 终结奖励 */
            type: number;
        };
    };
    40254: {
        desc: "领取俸禄";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    40255: {
        desc: "经验/贡献信息";
        send: (
            number: 40255,
            fmt: "c",
            args: [
                /**1: 经验 2: 贡献*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1: 经验 2: 贡献*/
            type: number
        ];
        recv: {
            /** 1: 经验 2: 贡献 */
            type: number;
            /** 累积经验 */
            exp: number;
        };
    };
    40256: {
        desc: "发送火苗列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 火苗波数 */
            wave: number;
            /** 下一波时间戳 */
            next_time: number;
        };
    };
    40257: {
        desc: "点击火苗";
        send: (
            number: 40257,
            fmt: "i",
            args: [
                /**火苗id*/
                fire_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**火苗id*/
            fire_id: number
        ];
        recv: {
            /** 奖励列表 */
            reward_list: any;
        };
    };
    40258: {
        desc: "下一个阶段提前推送信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0，未开启，1 篝火阶段， 2，答题阶段，3，巨龙阶段 */
            stage: number;
            /** 多少秒后进入下个阶段 */
            time: number;
        };
    };
    40259: {
        desc: "选择题答题";
        send: (
            number: 40259,
            fmt: "c",
            args: [
                /**答案*/
                answer: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**答案*/
            answer: number
        ];
        recv: null;
    };
    40260: {
        desc: "龙魂信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前龙魂数量 */
            dragon_spirit: number;
        };
    };
    40261: {
        desc: "购买龙魂";
        send: (
            number: 40261,
            fmt: "l",
            args: [
                /**龙魂数量*/
                dragon_spirit: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**龙魂数量*/
            dragon_spirit: number
        ];
        recv: null;
    };
    40262: {
        desc: "远古巨龙挑战结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1:成功， 2：失败 */
            status: number;
            /** 奖励列表 */
            reward_list: any;
        };
    };
    40263: {
        desc: "召唤巨龙";
        send: (
            number: 40263,
            fmt: "c",
            args: [
                /**远古巨龙类型 1：普通召唤 2：中级召唤 3：高级召唤*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**远古巨龙类型 1：普通召唤 2：中级召唤 3：高级召唤*/
            type: number
        ];
        recv: {
            /** 操作码 */
            code: number;
        };
    };
    40264: {
        desc: "吃菜";
        send: (
            number: 40264,
            fmt: "c",
            args: [
                /**菜肴类型 1 吃普通   2 优质   3极品*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**菜肴类型 1 吃普通   2 优质   3极品*/
            type: number
        ];
        recv: {
            /** 操作码 */
            code: number;
            food_list: {
                /** 菜肴类型 */
                type: number;
                /** 0 没吃  1 吃了 */
                status: number;
            }[];
        };
    };
    40265: {
        desc: "菜肴状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            food_list: {
                /** 菜肴类型 */
                type: number;
                /** 0没吃  1吃了 */
                status: number;
            }[];
        };
    };
    40266: {
        desc: "答题奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 公会排名 */
            rank: number;
            reward: any;
        };
    };
    40267: {
        desc: "公会经验加成";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 经验加成 */
            ratio: number;
        };
    };
}
