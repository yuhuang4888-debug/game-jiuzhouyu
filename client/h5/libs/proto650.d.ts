/** 跨服3v3
 */
declare interface ProtoFmtInfo {
    65000: {
        desc: "获取跨服3v3个人战绩";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 段位等级 */
            grade_num: number;
            /** 积分 */
            start_num: number;
            /** 连胜场数 */
            serial_win: number;
            /** 今日胜利场次 */
            daily_win: number;
            /** 今日参与次数 */
            daily_count: number;
            /** 赛季胜利次数 */
            season_win: number;
            /** 赛季参与次数 */
            season_count: number;
            reward_infos: {
                /** 0代表首胜奖励 >0代表参与多少次奖励 */
                index: number;
                /** 领取状态 0未领取  1:可以领取  2:已领取 */
                status: number;
            }[];
            /** 声望 */
            honor_value: number;
            /** 昨日段位 */
            yesterday_tier: number;
            /** 排名信息 */
            champion_rank: number;
            /** 0 未领取 1 领取了 */
            today_get: number;
            /** 赛季结束时间戳 */
            season_end_time: number;
            /** 活动结束时间戳 */
            act_end_time: number;
            /** 0 普通状态 1 匹配中 2 pk中 个人匹配状态 */
            matching_status: number;
        };
    };
    65001: {
        desc: "错误提示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    65002: {
        desc: "取消关注界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    65003: {
        desc: "领取今日段位奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            res: number;
        };
    };
    65004: {
        desc: "领取活跃奖励";
        send: (
            number: 65004,
            fmt: "c",
            args: [
                /**0代表首胜奖励 >0代表参与多少次奖励*/
                index: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0代表首胜奖励 >0代表参与多少次奖励*/
            index: number
        ];
        recv: {
            res: number;
            index: number;
        };
    };
    65005: {
        desc: "活动剩余时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            time: number;
        };
    };
    65010: {
        desc: "获取自身队伍信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            res: number;
            /** 队伍ID */
            team_id: number;
            /** 战力限制 */
            power_limit: number;
            /** 等级限制 */
            lv_limit: number;
            /** 入队密码 */
            team_psw: number;
            /** 是否满员自动开始（1：是；=1：否） */
            auto_start: number;
            /** 队长ID */
            leader_id: number;
            members: {
                server_name: string;
                /** 这个字段看看是不是可以不要了 */
                server_num: number;
                /** 这个字段看看是不是可以不要了 */
                server_id: number;
                role_id: number;
                role_name: string;
                career: number;
                sex: number;
                turn: number;
                power: number;
                /** 我们是[{部位,id,颜色}] */
                fashion: number;
                /** 我们是 [{部位,id}] */
                weapon: number;
                wing: number;
                /** 是否是队长（1:队长；=1:不是） */
                leader: number;
                /** 是否准备好 */
                ready: number;
            }[];
        };
    };
    65011: {
        desc: "获取3v3队伍信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            res: number;
            team_list: {
                /** 队伍ID */
                team_id: number;
                /**  队长服务器名 */
                leader_serv_name: string;
                /** 这个字段看看是不是可以不要了 */
                leader_serv_num: number;
                /** 队长ID */
                leader_id: number;
                /**  队长昵称 */
                leader_name: string;
                /** 队长等级 */
                leader_lv: number;
                /** 队长战力 */
                leader_power: number;
                /** 队伍人数 */
                team_num: number;
                /** 战力限制 */
                power_limit: number;
                /** 等级限制 */
                lv_limit: number;
                /** 是否需要密码（1：需要；=1：不需要） */
                need_psw: number;
                /** 是否满员自动开始（1：是；=1：否） */
                auto_start: number;
                career_list: {
                    /** 职业 */
                    career: number;
                }[];
            }[];
        };
    };
    65012: {
        desc: "查询3v3队伍信息(废弃)";
        send: (number: 65012, fmt: "l", args: [team_id: number]) => never;
        sendFmt: "l";
        sendArgs: [team_id: number];
        recv: {
            res: number;
            /** 队伍ID */
            team_id: number;
            /**  队长服务器名 */
            leader_serv_name: string;
            /** 这个字段看看是不是可以不要了 */
            leader_serv_num: number;
            /** 队长ID */
            leader_id: number;
            /**  队长昵称 */
            leader_name: string;
            /** 队长等级 */
            leader_lv: number;
            /** 队长战力 */
            leader_power: number;
            /** 队伍人数 */
            team_num: number;
            /** 战力限制 */
            power_limit: number;
            /** 等级限制 */
            lv_limit: number;
            /** 是否需要密码（1：需要；=1：不需要） */
            need_psw: number;
            /** 是否满员自动开始（1：是；=1：否） */
            auto_start: number;
        };
    };
    65014: {
        desc: "快速加入队伍（个人匹配";
        send: (
            number: 65014,
            fmt: "c",
            args: [
                /**1 开始匹配；2 取消匹配*/
                op: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1 开始匹配；2 取消匹配*/
            op: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 1 开始匹配；2 取消匹配 */
            op: number;
        };
    };
    65017: {
        desc: "离开队伍";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            res: number;
        };
    };
    65021: {
        desc: "开始匹配-广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            res: number;
        };
    };
    65022: {
        desc: "取消开始匹配-广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            res: number;
            /**  看看是否能去掉 */
            server_name: string;
            /** 看看是否能去掉 */
            server_num: number;
            role_id: number;
        };
    };
    65023: {
        desc: "准备|取消准备-广播";
        send: (
            number: 65023,
            fmt: "c",
            args: [
                /**是否准备好（1：是；=1：否）*/
                ready: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**是否准备好（1：是；=1：否）*/
            ready: number
        ];
        recv: {
            res: number;
            ready: number;
        };
    };
    65024: {
        desc: "自动开始|取消自动开始";
        send: (
            number: 65024,
            fmt: "c",
            args: [
                /**是否自动开始（1：是；=1：否）*/
                auto_start: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**是否自动开始（1：是；=1：否）*/
            auto_start: number
        ];
        recv: {
            res: number;
            auto_start: number;
        };
    };
    65025: {
        desc: "离队提醒-广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            server_name: string;
            server_num: number;
            role_id: number;
            role_name: string;
        };
    };
    65026: {
        desc: "被踢出提醒-广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    65027: {
        desc: "匹配结果提醒-广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    65029: {
        desc: "战力比对";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            team_list: {
                team_id: number;
                server_name: string;
                server_num: number;
                role_id: number;
                role_name: string;
                power: number;
                vip_lv: number;
                career: number;
                sex: number;
                lv: number;
                turn: number;
                /** 玩家上传的头像地址 */
                picture: string;
                /** 头像id */
                picture_id: number;
            }[];
        };
    };
    65030: {
        desc: "3v3战场信息";
        send: (number: 65030, fmt: "l", args: [team_id: number]) => never;
        sendFmt: "l";
        sendArgs: [team_id: number];
        recv: {
            res: number;
            /** 战斗剩余时间（秒数） */
            end_time: number;
            score: number;
            team_id: number;
            progress_rate: {
                /** 1：蓝色 2：红色  0：未被占领 */
                team_group: number;
                /** 祭坛id */
                tower_id: number;
                /** 进度(百分比数) */
                rate: number;
            }[];
            enemy_score: number;
            enemy_team_id: number;
        };
    };
    65031: {
        desc: "神塔占领-广播(废弃)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    65032: {
        desc: "异常退出战斗-广播(废弃)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            team_id: number;
            server_name: string;
            server_num: number;
            role_id: number;
        };
    };
    65033: {
        desc: "重新进入战斗-广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            team_id: number;
            server_name: string;
            server_num: number;
            role_id: number;
        };
    };
    65035: {
        desc: "积分变更-广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 蓝队 */
            score1: number;
            /** 红队 */
            score2: number;
        };
    };
    65036: {
        desc: "玩家战场数据变更-广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /**  平台 */
            server_name: string;
            /** 服号 */
            server_num: number;
            /** 玩家ID */
            role_id: number;
            /** 击杀次数 */
            kill_count: number;
            /** 被击杀次数 */
            die_count: number;
            /** 占据神塔次数 */
            hold_count: number;
        };
    };
    65037: {
        desc: "战斗结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 个人排位赛  1排位赛 2 冠军赛  3  观战 */
            type: number;
            /** 胜利组别（0：平局；1：组别1胜利；2：组别2胜利） */
            win_side: number;
            /** 红方积分 */
            red_point: number;
            /** 蓝方积分 */
            blue_point: number;
            /** 占据神塔数量 */
            hold_count1: number;
            role_list1: {
                server_name: string;
                server_num: number;
                role_id: number;
                role_name: string;
                career: number;
                sex: number;
                lv: number;
                turn: number;
                power: number;
                /** 击杀次数 */
                kill_count: number;
                /** 助攻次数 */
                assist_count: number;
                /** 被击杀次数 */
                die_count: number;
                /** 占据神塔次数 */
                hold_count: number;
                /** 是否是MVP（1：是；=1：否） */
                mvp: number;
            }[];
            /** 占据神塔数量 */
            hold_count2: number;
            role_list2: {
                server_name: string;
                server_num: number;
                role_id: number;
                role_name: string;
                career: number;
                sex: number;
                lv: number;
                turn: number;
                power: number;
                /** 击杀次数 */
                kill_count: number;
                /** 助攻次数 */
                assist_count: number;
                /** 被击杀次数 */
                die_count: number;
                /** 占据神塔次数 */
                hold_count: number;
                /** 是否是MVP（1：是；=1：否） */
                mvp: number;
            }[];
            /** 所得积分 */
            start_num: number;
            /** 当前是几连胜 */
            serial_win: number;
            /** 所得声望 */
            honor_value: number;
            /** 段位id */
            tier_id: number;
        };
    };
    65038: {
        desc: "获取天梯排行榜-活动结束推送20强(废弃)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_list: {
                /** 排 */
                rank: number;
                /** 段位等级 */
                tier_id: number;
                server_name: string;
                server_num: number;
                role_name: string;
                /** 当前积分 */
                start_num: number;
            }[];
        };
    };
    65039: {
        desc: "获取荣誉排行榜-每页最多5个排名(废弃)";
        send: (number: 65039, fmt: "c", args: [page: number]) => never;
        sendFmt: "c";
        sendArgs: [page: number];
        recv: {
            page: number;
            role_list: {
                server_name: string;
                server_num: number;
                server_id: number;
                role_id: number;
                role_name: string;
                career: number;
                sex: number;
                grade_num: number;
                start_num: number;
                power: number;
            }[];
            /** 昨日段位 */
            yesterday_grade: number;
            /** 昨日星数 */
            yesterday_start: number;
            /** 排名 */
            rank: number;
            /** 段位奖励 */
            grade_reward: number;
        };
    };
    65040: {
        desc: "离开战场";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    65041: {
        desc: "公开招募(废弃)";
        send: (
            number: 65041,
            fmt: "c",
            args: [
                /**招募范围 1世界 2帮派*/
                range: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**招募范围 1世界 2帮派*/
            range: number
        ];
        recv: null;
    };
    65042: {
        desc: "进出塔";
        send: (
            number: 65042,
            fmt: "cc",
            args: [
                /**1 进入塔  0 出塔*/
                behavior: number,
                /**祭坛id*/
                tower_id: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**1 进入塔  0 出塔*/
            behavior: number,
            /**祭坛id*/
            tower_id: number
        ];
        recv: null;
    };
    65043: {
        desc: "玩家信息";
        send: (number: 65043, fmt: "l", args: [team_id: number]) => never;
        sendFmt: "l";
        sendArgs: [team_id: number];
        recv: {
            role_list: {
                /** 1：蓝色 2：红色 */
                team_group: number;
                server_name: string;
                server_num: number;
                role_id: number;
                role_name: string;
                /** 玩家战力 */
                power: number;
                career: number;
                sex: number;
                lv: number;
                turn: number;
                /** 击杀次数 */
                kill_count: number;
                /** 助攻次数 */
                assist_count: number;
                /** 连杀次数 */
                continuous_kill_count: number;
                /** 被击杀次数 */
                die_count: number;
            }[];
        };
    };
    65044: {
        desc: "占领信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 祭坛id */
            tower_id: number;
            /** 占领红蓝方 */
            team_group: number;
            /** 1 增长 0:减少 */
            type: number;
            /** 结束时间戳 */
            end_time: number;
            /** 当前进度 */
            rate: number;
        };
    };
    65045: {
        desc: "声望奖励领取信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward_list: {
                /** 阶段id */
                id: number;
                /** 领取状态 0未领取  1:可以领取  2:已领取 */
                status: number;
            }[];
        };
    };
    65047: {
        desc: "领取声望奖励";
        send: (
            number: 65047,
            fmt: "c",
            args: [
                /**奖励id*/
                id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**奖励id*/
            id: number
        ];
        recv: {
            /** 奖励id */
            id: number;
            /** 奖励列表 */
            reward: any;
        };
    };
    65048: {
        desc: "连杀次数";
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
    65049: {
        desc: "创建战队";
        send: (
            number: 65049,
            fmt: "s",
            args: [
                /**战队名字*/
                name: string
            ]
        ) => never;
        sendFmt: "s";
        sendArgs: [
            /**战队名字*/
            name: string
        ];
        recv: {
            /** 操作码 */
            code: number;
        };
    };
    65050: {
        desc: "申请战队战队";
        send: (
            number: 65050,
            fmt: "l",
            args: [
                /**战队id*/
                team_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**战队id*/
            team_id: number
        ];
        recv: {
            /** 战队id */
            team_id: number;
            /** 操作码 */
            code: number;
        };
    };
    65051: {
        desc: "战队列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            team_list: {
                /** 战队id */
                team_id: number;
                /** 战队名字 */
                team_name: string;
                point: number;
                /** 队长id */
                leader_id: number;
                /** 队长名字 */
                leader_name: string;
                /** 人数 */
                num: number;
                /** 排名 */
                rank: number;
                /** 0 未申请  1 已申请 */
                status: number;
            }[];
        };
    };
    65052: {
        desc: "战队信息";
        send: (number: 65052, fmt: "l", args: [team_id: number]) => never;
        sendFmt: "l";
        sendArgs: [team_id: number];
        recv: {
            /** 队伍ID */
            team_id: number;
            /** 0 自己队 1 别人队 */
            flag: number;
            team_name: string;
            /** 队长ID */
            leader_id: number;
            /** 赛季匹配次数 */
            match_count: number;
            /** 胜利场次 */
            win_count: number;
            point: number;
            /** 匹配状态   0 普通状态  1 匹配中 2 pk中 */
            status: number;
            rank: number;
            /** 段位 */
            rank_lv: number;
            /** 总战力 */
            power: number;
            /** 0 未 改过名 1 改过名 */
            change_name: number;
            members: {
                server_id: number;
                server_name: string;
                server_num: number;
                role_id: number;
                role_name: string;
                /** 1 在线  0 离线 */
                on_line: number;
                /** 是否是队长（1:队长；=1:不是） */
                leader: number;
            }[];
        };
    };
    65053: {
        desc: "踢出战队";
        send: (
            number: 65053,
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
            /** 玩家id */
            role_id: number;
            /** 操作码 */
            code: number;
        };
    };
    65054: {
        desc: "转让队长";
        send: (
            number: 65054,
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
            /** 玩家id */
            role_id: number;
            /** 操作码 */
            code: number;
        };
    };
    65055: {
        desc: "解散队伍";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 操作码 */
            code: number;
        };
    };
    65056: {
        desc: "退出队伍";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 操作码 */
            code: number;
        };
    };
    65057: {
        desc: "战队排名";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rank_list: {
                team_id: number;
                rank: number;
                /** 玩家id */
                leader_id: number;
                /** 玩家排名 */
                leader_name: string;
                /** 队长所在服 */
                server_num: number;
                /** 队长所在服 */
                server_name: string;
                /** 战队名字 */
                team_name: string;
                /** 总战力 */
                power: number;
                /** 总评分 */
                point: number;
            }[];
        };
    };
    65058: {
        desc: "改名";
        send: (number: 65058, fmt: "s", args: [name: string]) => never;
        sendFmt: "s";
        sendArgs: [name: string];
        recv: {
            name: string;
            code: number;
        };
    };
    65059: {
        desc: "申请列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_list: {
                /** 玩家id */
                role_id: number;
                /**  名字 */
                role_name: string;
                /** 玩家上传的头像地址 */
                picture: string;
                /** 头像id */
                picture_id: number;
                /** 职业 */
                career: number;
                /** 等级 */
                lv: number;
                /** 战力 */
                combat_power: number;
            }[];
        };
    };
    65060: {
        desc: "操作申请列表";
        send: (
            number: 65060,
            fmt: "lc",
            args: [
                /**玩家id*/
                role_id: number,
                /**0 拒绝  1 ：同意*/
                type: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**玩家id*/
            role_id: number,
            /**0 拒绝  1 ：同意*/
            type: number
        ];
        recv: {
            /** 玩家id */
            role_id: number;
            type: number;
            /** 错误码 */
            code: number;
        };
    };
    65061: {
        desc: "世界招募";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    65062: {
        desc: "个人招募";
        send: (
            number: 65062,
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
            code: number;
        };
    };
    65063: {
        desc: "个人招募2";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 队长id */
            leader_id: number;
            /** 队长名字 */
            leader_name: string;
            /** 战队id */
            team_id: number;
            /** 战队名字 */
            team_name: string;
        };
    };
    65064: {
        desc: "快速入队";
        send: (
            number: 65064,
            fmt: "l",
            args: [
                /**队伍id*/
                team_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**队伍id*/
            team_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    65065: {
        desc: "招募列表";
        send: (
            number: 65065,
            fmt: "c",
            args: [
                /**1:公会;2:好友*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1:公会;2:好友*/
            type: number
        ];
        recv: {
            /** 1:公会;2:好友 */
            type: number;
            array_list: {
                /** 玩家id */
                role_id: number;
                /**  名字 */
                role_name: string;
                /** 玩家上传的头像地址 */
                picture: string;
                /** 头像id */
                picture_id: number;
                /** 职业 */
                career: number;
                /** 等级 */
                lv: number;
                /** 战力 */
                combat_power: number;
            }[];
        };
    };
    65066: {
        desc: "广播发起投票";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 结束时间戳 */
            end_time: number;
        };
    };
    65067: {
        desc: "队员投票";
        send: (
            number: 65067,
            fmt: "c",
            args: [
                /**(0:反对 1:赞同)*/
                res: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**(0:反对 1:赞同)*/
            res: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** (0:反对 1:赞同) */
            res: number;
        };
    };
    65068: {
        desc: "广播队员投票";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 名字 */
            role_name: string;
            /** (0:反对 1:赞同) */
            res: number;
        };
    };
    65069: {
        desc: "广播投票结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** (1:成功 0:失败) */
            res: number;
        };
    };
    65070: {
        desc: "个人申请通知(通知队长)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            server_id: number;
            server_num: number;
            /** 玩家id */
            role_id: number;
            role_name: string;
            combat_power: number;
            lv: number;
            /** 玩家上传的头像地址 */
            picture: string;
            /** 头像id */
            picture_id: number;
            /** 职业 */
            career: number;
        };
    };
    65071: {
        desc: "投票参与队员";
        send: (number: 65071, fmt: "l", args: [team_id: number]) => never;
        sendFmt: "l";
        sendArgs: [team_id: number];
        recv: {
            role_list: {
                /** 玩家id */
                role_id: number;
            }[];
        };
    };
    65072: {
        desc: "战队操作列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 队伍id */
            team_id: number;
            /** 0 拒绝  1 ：同意 */
            type: number;
        };
    };
    65073: {
        desc: "催队长";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功  2 失败 */
            code: number;
        };
    };
    65074: {
        desc: "队长收到催促信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_id: number;
            role_name: string;
        };
    };
    65075: {
        desc: "冠军赛信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 开始时间 */
            start_time: number;
            team_list: {
                /** 队伍id */
                team_id: number;
                /** 队伍名字1 */
                team_name: string;
                /** 服务器id */
                server_id: number;
                server_num: number;
                server_name: string;
                /** 位置 */
                pos: number;
                /** 胜利次数 */
                win_count: number;
            }[];
        };
    };
    65076: {
        desc: "进入冠军赛场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    65077: {
        desc: "离开冠军赛场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    65078: {
        desc: "冠军赛场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前轮次 */
            turn: number;
            /** 胜利次数 */
            win_count: number;
            /** 人数 */
            num: number;
            /** 0关闭状态  1 开启状态 2 pk状态  3 竞猜状态 */
            stage: number;
            /** 是否轮空  0 轮空 1  不轮空 */
            wheel_space: number;
            /** 阶段结束时间戳 */
            stage_end_time: number;
        };
    };
    65079: {
        desc: "召集队员";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_name: string;
        };
    };
    65080: {
        desc: "竞猜";
        send: (
            number: 65080,
            fmt: "cllcii",
            args: [
                turn: number,
                team_a_id: number,
                team_b_id: number,
                opt: number,
                cost_type: number,
                cost_num: number
            ]
        ) => never;
        sendFmt: "cllcii";
        sendArgs: [
            turn: number,
            team_a_id: number,
            team_b_id: number,
            opt: number,
            cost_type: number,
            cost_num: number
        ];
        recv: {
            code: number;
        };
    };
    65081: {
        desc: "竞猜列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            turn: number;
            guess_list: {
                team_a_id: number;
                team_b_id: number;
                team_a_name: string;
                team_b_name: string;
                opt: number;
                cost_type: number;
                cost_num: number;
            }[];
        };
    };
    65082: {
        desc: "竞猜记录列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            guess_list: {
                /** 轮次 */
                turn: number;
                team_a_id: number;
                team_b_id: number;
                team_a_name: string;
                team_b_name: string;
                /** 选项 */
                opt: number;
                /** 1 对  2 错 */
                result: number;
                reward_type: number;
                reward_num: number;
                /** 正确选项 */
                right_result: number;
                /** 0 不可以领取  1可以领取 2已经领取 ， */
                status: number;
                /** 竞猜时间 */
                time: number;
            }[];
        };
    };
    65083: {
        desc: "领取竞猜奖励";
        send: (
            number: 65083,
            fmt: "clli",
            args: [
                turn: number,
                team_a_id: number,
                team_b_id: number,
                /**竞猜时间*/
                time: number
            ]
        ) => never;
        sendFmt: "clli";
        sendArgs: [
            turn: number,
            team_a_id: number,
            team_b_id: number,
            /**竞猜时间*/
            time: number
        ];
        recv: {
            /** 操作码 */
            code: number;
            reward_list: any;
        };
    };
    65084: {
        desc: "战队信息";
        send: (number: 65084, fmt: "l", args: [team_id: number]) => never;
        sendFmt: "l";
        sendArgs: [team_id: number];
        recv: {
            /** 队伍ID */
            team_id: number;
            team_name: string;
            /** 队长ID */
            leader_id: number;
            /** 赛季匹配次数 */
            match_count: number;
            /** 胜利场次 */
            win_count: number;
            /** 大段位 */
            rank: number;
            /** 段位等级 */
            rank_lv: number;
            point: number;
            /** 总战力 */
            power: number;
            members: {
                server_id: number;
                server_name: string;
                server_num: number;
                role_id: number;
                /** 是否是队长（1:队长；=1:不是） */
                leader: number;
            }[];
        };
    };
    65085: {
        desc: "战力比对竞猜使用的";
        send: (
            number: 65085,
            fmt: "ll",
            args: [team_a_id: number, team_b_id: number]
        ) => never;
        sendFmt: "ll";
        sendArgs: [team_a_id: number, team_b_id: number];
        recv: {
            team_list: {
                team_name: string;
                team_id: number;
                server_name: string;
                server_num: number;
                role_id: number;
                role_name: string;
                power: number;
                vip_lv: number;
                career: number;
                sex: number;
                lv: number;
                turn: number;
                /** 玩家上传的头像地址 */
                picture: string;
                /** 头像id */
                picture_id: number;
            }[];
        };
    };
    65086: {
        desc: "观战";
        send: (number: 65086, fmt: "l", args: [team_id: number]) => never;
        sendFmt: "l";
        sendArgs: [team_id: number];
        recv: {
            code: number;
            team_id: number;
            other_team_id: number;
            leader_a_id: number;
            leader_b_id: number;
        };
    };
    65087: {
        desc: "退出观战";
        send: (number: 65087, fmt: "l", args: [team_id: number]) => never;
        sendFmt: "l";
        sendArgs: [team_id: number];
        recv: null;
    };
    65088: {
        desc: "阶段状态信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
            stage: number;
            end_time: number;
        };
    };
}
