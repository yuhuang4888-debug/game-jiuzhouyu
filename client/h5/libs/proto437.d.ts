/** 跨服公会战
 */
declare interface ProtoFmtInfo {
    43700: {
        desc: "返回码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
            /**  参数 */
            args: string;
        };
    };
    43701: {
        desc: "活动状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0:未开始 1:宣战期 2:确认期 3:战斗期 4:空窗期 */
            stage: number;
            /** 轮次 */
            round: number;
            /** 比赛类型 1: 外海战 2: 内海战 */
            game_type: number;
            /** 当前阶段结束时间戳 */
            etime: number;
        };
    };
    43702: {
        desc: "海域总览信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            island_ids: {
                /** 本服占领的岛屿id */
                island_id: number;
            }[];
        };
    };
    43703: {
        desc: "各个海域信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 日常奖励状态 0: 不可领取 1: 可领取 */
            reward_status: number;
            /** 本公会有资格参加的岛屿id 0: 表示没有 */
            entitled_island_id: number;
            island_list: {
                /** 岛屿id */
                island_id: number;
                /**  服务器名字 */
                server_name: string;
                /** 占领的公会id */
                guild_id: number;
                /**  占领的公会名字 */
                guild_name: string;
            }[];
        };
    };
    43704: {
        desc: "本服奖励界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 日常奖励状态 0: 不可领取 1: 可领取 */
            reward_status: number;
            reward_list: {
                /** 海域类型 1: 贫瘠海域 2: 外海域 3: 内海域 4: 中央海域 */
                seas_type: number;
                /** 海域子类型 0: 无 1: 北海 2: 东海 3: 西海 */
                seas_subtype: number;
                /** 岛屿id */
                island_id: number;
                /**  服务器名字 */
                server_name: string;
                /**  占领公会名字 */
                guild_name: string;
            }[];
        };
    };
    43705: {
        desc: "一键领取本服奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 1: 成功 */
            errcode: number;
        };
    };
    43706: {
        desc: "赛季奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward_list: {
                /** 排名 */
                ranking: number;
                /**  服务器名字 */
                server_name: string;
                /** 公会id 0: 表示没有 */
                guild_id: number;
                /**  公会名字 */
                guild_name: string;
                /** 积分 */
                score: number;
                reward: any;
            }[];
        };
    };
    43707: {
        desc: "海域霸王界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /**  服务器名字 */
            server_name: string;
            /** 公会id 0: 表示没有 */
            guild_id: number;
            /**  公会名字 */
            guild_name: string;
            /** 占领天数 */
            occupation_days: number;
        };
    };
    43708: {
        desc: "物资捐献界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            guild_list: {
                /** 公会id, 如果本服没有公会公会id会为0 */
                guild_id: number;
                /**  公会名字 */
                guild_name: string;
                /** 排名 */
                ranking: number;
                /** 占领的岛屿id 0:表示未占领 */
                island_id: number;
                /** 资源数量 */
                resources: number;
                /** 宣战资金 */
                funds: number;
                donate_status: {
                    /** 1: 物资捐献 2: 钻石捐献 */
                    type: number;
                    /** 剩余次数 */
                    remain_times: number;
                }[];
            }[];
        };
    };
    43709: {
        desc: "物资捐献";
        send: (
            number: 43709,
            fmt: "lc",
            args: [
                /**对哪个公会捐赠物资*/
                guild_id: number,
                /**1: 物资捐献 2: 钻石捐献*/
                type: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**对哪个公会捐赠物资*/
            guild_id: number,
            /**1: 物资捐献 2: 钻石捐献*/
            type: number
        ];
        recv: {
            /** 返回码 1: 成功 */
            errcode: number;
        };
    };
    43710: {
        desc: "兑换物资界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 资源数量 */
            resources: number;
            list: {
                /** 物资id */
                id: number;
                /** 拥有数量 */
                num: number;
            }[];
        };
    };
    43711: {
        desc: "兑换物资";
        send: (
            number: 43711,
            fmt: "chc",
            args: [
                /**要兑换的物资id*/
                id: number,
                /**兑换数量*/
                num: number,
                /**1: 物资兑换 2: 钻石兑换*/
                type: number
            ]
        ) => never;
        sendFmt: "chc";
        sendArgs: [
            /**要兑换的物资id*/
            id: number,
            /**兑换数量*/
            num: number,
            /**1: 物资兑换 2: 钻石兑换*/
            type: number
        ];
        recv: {
            /** 返回码 1: 成功 */
            errcode: number;
        };
    };
    43712: {
        desc: "个人积分";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阵营id */
            group_id: number;
            /** 积分 */
            score: number;
            stage_reward: {
                /** 阶段奖励id */
                key_id: number;
                /** 0: 未达成 1: 已达成未领取 2: 已领取 */
                state: number;
            }[];
        };
    };
    43713: {
        desc: "公会积分(显示公会排名的时候3秒请求一次)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            guild_list: {
                /** 阵营id */
                group_id: number;
                /**  公会名 */
                guild_name: string;
                /** 积分 */
                score: number;
                /** 积分更新时间 */
                utime: number;
            }[];
        };
    };
    43714: {
        desc: "据点占领列表(只发已经被占领的)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            building_list: {
                /** 建筑id */
                mon_id: number;
                /** 分组 0: 表示中立 */
                group: number;
                /** 占领的公会id 0: 表示未被公会占领 */
                guild_id: number;
                /**  占领公会名 */
                guild_name: string;
                /** 血量 */
                hp: number;
            }[];
        };
    };
    43715: {
        desc: "兑换战舰界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家积分 */
            score: number;
            /** 已经拥有的战舰id */
            ship_ids: {
                ship_id: number;
            }[];
        };
    };
    43716: {
        desc: "兑换战舰";
        send: (
            number: 43716,
            fmt: "c",
            args: [
                /**战舰id*/
                id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**战舰id*/
            id: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 战舰id */
            id: number;
        };
    };
    43717: {
        desc: "使用物资界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 物资id */
                id: number;
                /** 数量 */
                num: number;
                /** 已使用数量 */
                use_num: number;
            }[];
        };
    };
    43718: {
        desc: "使用物资";
        send: (
            number: 43718,
            fmt: "c",
            args: [
                /**物资id*/
                id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**物资id*/
            id: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
        };
    };
    43719: {
        desc: "进入/离开战场";
        send: (
            number: 43719,
            fmt: "c",
            args: [
                /**1: 进入 2: 离开*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1: 进入 2: 离开*/
            type: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 1: 进入 2: 离开 */
            type: number;
        };
    };
    43720: {
        desc: "回到陆地/下海";
        send: (
            number: 43720,
            fmt: "c",
            args: [
                /**0: 回到陆地 1: 下海*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0: 回到陆地 1: 下海*/
            type: number
        ];
        recv: {
            /** 返回码 成功返回 1 */
            errcode: number;
        };
    };
    43721: {
        desc: "结算界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 占领海神像的公会id 0:表示没有公会占领海神像 */
            ownership_id: number;
            /** 获胜的公会所在服务器id */
            winner_sid: number;
            /** 获胜的公会id */
            winner_id: number;
            guild_list: {
                /** 排名 */
                ranking: number;
                /** 公会id */
                guild_id: number;
                /**  公会名字 */
                guild_name: string;
                /** 总积分 */
                score: number;
                /** 获得的赛季积分 */
                score_plus: number;
                reward: any;
            }[];
        };
    };
    43722: {
        desc: "击杀排行";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 排名 */
                ranking: number;
                /** 服务器id */
                server_id: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 击杀数 */
                kill_num: number;
                /** 连杀数 */
                combo: number;
                reward: any;
            }[];
        };
    };
    43723: {
        desc: "更新船坞建筑血量";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 建筑id */
            id: number;
            /** 血量 */
            hp: number;
        };
    };
    43724: {
        desc: "更新船坞建筑归属";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 建筑id */
            id: number;
            /** 分组 0: 表示中立 */
            group: number;
            /** 占领的公会id 0: 表示未被公会占领 */
            guild_id: number;
            /**  占领公会名 */
            guild_name: string;
            /** 血量 */
            hp: number;
        };
    };
    43725: {
        desc: "更新个人积分";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 积分 */
            score: number;
        };
    };
    43726: {
        desc: "岛屿宣战信息";
        send: (
            number: 43726,
            fmt: "c",
            args: [
                /**岛屿id*/
                island_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**岛屿id*/
            island_id: number
        ];
        recv: {
            /** 岛屿id */
            island_id: number;
            /** 占领的公会id 0: 表示未被公会占领 */
            guild_id: number;
            /**  占领公会名 */
            guild_name: string;
            /** 0:未开始 1:宣战期 2:确认期 3:战斗期 4:空窗期 */
            stage: number;
            /** 本公会是否已经宣战这个岛屿 0: 没有 1: 有 */
            is_bid: number;
            /** 宣战列表 */
            appoint_list: {
                /**  服务器名字 */
                server_name: string;
                /**  公会名字 */
                guild_name: string;
                /** 出价 */
                bid: number;
                /** 出价时间 */
                time: number;
            }[];
        };
    };
    43727: {
        desc: "宣战出价界面";
        send: (
            number: 43727,
            fmt: "c",
            args: [
                /**岛屿id*/
                island_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**岛屿id*/
            island_id: number
        ];
        recv: {
            /** 最低宣战公会资金 */
            min_bid: number;
            /** 拥有的公会资金 */
            gfunds: number;
        };
    };
    43728: {
        desc: "宣战";
        send: (
            number: 43728,
            fmt: "ci",
            args: [
                /**岛屿id*/
                island_id: number,
                /**出价*/
                bid: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**岛屿id*/
            island_id: number,
            /**出价*/
            bid: number
        ];
        recv: {
            /** 返回码 成功返回 1 */
            errcode: number;
            /** 岛屿id */
            island_id: number;
        };
    };
    43729: {
        desc: "取消宣战";
        send: (
            number: 43729,
            fmt: "c",
            args: [
                /**岛屿id*/
                island_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**岛屿id*/
            island_id: number
        ];
        recv: {
            /** 返回码 成功返回 1 */
            errcode: number;
            /** 岛屿id */
            island_id: number;
        };
    };
    43730: {
        desc: "海域霸王玩家figure";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_list: {
                /** 1: 会长 2: 副会长 3: 会长伴侣 */
                pos: number;
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
    43731: {
        desc: "战斗场景信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 战斗结束时间 */
            etime: number;
            /** 玩家禁止释放技能状态结束时间戳 */
            forbid_pl_etime: number;
        };
    };
    43732: {
        desc: "召集";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** X坐标 */
            x: number;
            /** Y坐标 */
            y: number;
        };
    };
    43733: {
        desc: "响应召集";
        send: (
            number: 43733,
            fmt: "hh",
            args: [
                /**X坐标*/
                x: number,
                /**Y坐标*/
                y: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**X坐标*/
            x: number,
            /**Y坐标*/
            y: number
        ];
        recv: {
            /** 返回码 成功返回 1 */
            errcode: number;
        };
    };
    43734: {
        desc: "复活";
        send: (
            number: 43734,
            fmt: "hh",
            args: [
                /**X坐标*/
                x: number,
                /**Y坐标*/
                y: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**X坐标*/
            x: number,
            /**Y坐标*/
            y: number
        ];
        recv: null;
    };
    43735: {
        desc: "阶段提示弹窗通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1:会长弹宣战弹窗其他人弹捐献弹窗 2:战斗开始弹窗 */
            type: number;
        };
    };
}
