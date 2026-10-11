/** 矿石护送
 */
declare interface ProtoFmtInfo {
    18600: {
        desc: "海域信息界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阵营（东西南北） */
            camp: number;
            /** 第一公会服id */
            server_id: number;
            /** 第一公会服数 */
            server_num: number;
            /**  第一公会服务器信息 */
            c_server_msg: string;
            /** 第一名公会id */
            guild_id: number;
            /**  第一名公会名 */
            guild_name: string;
            /**  海域之王名字 */
            king_name: string;
            /** 海域战力 */
            fight: number;
            /** 海域人数 */
            count: number;
            /** 自己职位id */
            self_level: number;
            /** 每日奖励领取状态 0未领取 1已领取 2未达成 */
            reward_status: number;
        };
    };
    18601: {
        desc: "海王禁卫";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 人数上限 */
            limit_num: number;
            /** 当前人数 */
            num: number;
            /** 自己是否加入了 0否 1是 */
            has_join: number;
            job_list: {
                /** 职位id */
                self_level: number;
                /** 服id */
                server_id: number;
                /** 服数 */
                server_num: number;
                /**  第一公会服务器信息 */
                c_server_msg: string;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 玩家等级 */
                role_lv: number;
                /**  玩家头像 */
                picture: string;
                /** 头像版本号 */
                picture_ver: number;
                /** 战力 */
                power: number;
            }[];
        };
    };
    18602: {
        desc: "审批设置";
        send: (
            number: 18602,
            fmt: "hlc",
            args: [
                /**限制等级*/
                role_lv: number,
                /**战力限制*/
                power: number,
                /**自动同意申请 0否 1是*/
                auto: number
            ]
        ) => never;
        sendFmt: "hlc";
        sendArgs: [
            /**限制等级*/
            role_lv: number,
            /**战力限制*/
            power: number,
            /**自动同意申请 0否 1是*/
            auto: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    18603: {
        desc: "申请加入海军禁卫";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    18604: {
        desc: "查看禁卫申请";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /**  头像 */
                picture: string;
                /** 头像版本号 */
                picture_ver: number;
                /** 等级 */
                role_lv: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 战力 */
                power: number;
            }[];
        };
    };
    18605: {
        desc: "处理禁卫申请";
        send: (
            number: 18605,
            fmt: "cl",
            args: [
                /**是否同意 0否 1是 2一键同意 3一键拒绝*/
                agree: number,
                /**玩家id  一键同意、一键拒绝时发0*/
                role_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**是否同意 0否 1是 2一键同意 3一键拒绝*/
            agree: number,
            /**玩家id  一键同意、一键拒绝时发0*/
            role_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    18606: {
        desc: "职位管理";
        send: (
            number: 18606,
            fmt: "hA",
            args: [
                /**职位*/
                level: number,
                role_list: any
            ]
        ) => never;
        sendFmt: "hA";
        sendArgs: [
            /**职位*/
            level: number,
            role_list: any
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    18607: {
        desc: "海域争夺开启时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1争夺 2争霸 */
            act_type: number;
            /** 是否打过海域争夺战 0 不是 1是 */
            has_fight: number;
            /** 开启时间戳 */
            start_time: number;
            /** 结束时间 */
            end_time: number;
            /** 0无参与资格 1有资格 */
            can_enter: number;
        };
    };
    18608: {
        desc: "海域争夺公会列表";
        send: (number: 18608, fmt: "i", args: [camp: number]) => never;
        sendFmt: "i";
        sendArgs: [camp: number];
        recv: {
            camp: number;
            guild_list: {
                /** 排名 */
                rank: number;
                /** 服id */
                server_id: number;
                /** 服数 */
                server_num: number;
                /**  第一公会服务器信息 */
                c_server_msg: string;
                /** 公会id */
                guild_id: number;
                /**  公会名字 */
                guild_name: string;
                /** 公会战力 */
                guild_power: number;
                /**  会长名 */
                role_name: string;
                /** 会长id */
                role_id: number;
            }[];
        };
    };
    18609: {
        desc: "怪物数据(场景内)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 怪物id */
                mon_id: number;
                /** 血量 */
                hp: number;
                /** 血量上限 */
                hp_max: number;
                /** 0不允许被攻击 1允许被攻击 */
                att_limit: number;
                /** 下个怪物 */
                next_mon: number;
            }[];
        };
    };
    18610: {
        desc: "战舰切换";
        send: (
            number: 18610,
            fmt: "c",
            args: [
                /**1战列舰 2攻城舰*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1战列舰 2攻城舰*/
            type: number
        ];
        recv: {
            /** 1战列舰 2攻城舰 */
            type: number;
            /** 返回码 */
            code: number;
            /** 下次可切换时间 */
            time: number;
        };
    };
    18611: {
        desc: "战场统计";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            score_rank: {
                /** 公会id阵营id */
                guild_id: number;
                /**  公会名阵营名 */
                guild_name: string;
                /** 1进攻方 2防守方 */
                is_att: number;
                /** 排名 */
                guild_rank: number;
                /** 积分 */
                guild_score: number;
                member: {
                    /** 公会内部排名 */
                    rank: number;
                    /** 玩家id */
                    role_id: number;
                    /**  玩家名 */
                    role_name: string;
                    /** 击杀积分 */
                    kill_score: number;
                    /** 积分 */
                    score: number;
                }[];
            }[];
        };
    };
    18612: {
        desc: "结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功  0 失败 */
            status: number;
            /** 公会排名 */
            guild_rank: number;
            /** 个人排名 */
            self_rank: number;
            rank_reward: any;
            reward: any;
        };
    };
    18613: {
        desc: "进入";
        send: (
            number: 18613,
            fmt: "i",
            args: [
                /**场景id*/
                scene: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**场景id*/
            scene: number
        ];
        recv: {
            /** 1战列舰 2攻城舰 */
            type: number;
            /** 返回码 */
            code: number;
        };
    };
    18614: {
        desc: "退出";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    18615: {
        desc: "海域霸主界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阵营（东西南北） */
            camp: number;
            /** 第一公会服id */
            server_id: number;
            /** 第一公会服数 */
            server_num: number;
            c_server_msg: string;
            /** 第一名公会id */
            guild_id: number;
            /**  第一名公会名 */
            guild_name: string;
            /** 连胜次数 */
            times: number;
            /** 争霸开始时间 */
            start_time: number;
            /** 争霸结束时间 */
            end_time: number;
            /** 连胜奖励 为空表示未获得 */
            win_reward_status: {
                /** 连胜次数 */
                times: number;
                /** 分配状态 1未分配 2已分配 */
                status: number;
            }[];
        };
    };
    18616: {
        desc: "连胜分配";
        send: (
            number: 18616,
            fmt: "ilc",
            args: [
                /**服id*/
                server_id: number,
                /**玩家id*/
                role_id: number,
                /**连胜次数*/
                times: number
            ]
        ) => never;
        sendFmt: "ilc";
        sendArgs: [
            /**服id*/
            server_id: number,
            /**玩家id*/
            role_id: number,
            /**连胜次数*/
            times: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    18617: {
        desc: "攻守方";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 进攻方 */
            att: {
                server_id: number;
                server_num: number;
                c_server_msg: string;
                guild_id: number;
                guild_name: string;
            }[];
            /** 防守方 */
            def: {
                server_id: number;
                server_num: number;
                c_server_msg: string;
                guild_id: number;
                guild_name: string;
            }[];
        };
    };
    18618: {
        desc: "势力列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 阵营 */
                camp: number;
                server_id: number;
                server_num: number;
                c_server_msg: string;
                /** 最强公会 */
                guild_id: number;
                guild_name: string;
                /** 公会战力 */
                power: number;
                /** 最强公会会长 */
                role_id: number;
                role_name: string;
            }[];
        };
    };
    18619: {
        desc: "加入势力";
        send: (number: 18619, fmt: "i", args: [camp: number]) => never;
        sendFmt: "i";
        sendArgs: [camp: number];
        recv: {
            code: number;
        };
    };
    18620: {
        desc: "退出势力";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    18621: {
        desc: "领取每日福利";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward: any;
            /** 返回码 */
            code: number;
        };
    };
    18622: {
        desc: "查看本阵营申请限制";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 限制等级 */
            role_lv: number;
            /** 战力限制 */
            power: number;
            /** 自动同意申请 0否 1是 */
            auto: number;
        };
    };
    18623: {
        desc: "活动时间更新标志协议";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 0点、活动开启更新本地活动时间后主动推 2 活动结束后主动推 */
            code: number;
        };
    };
    18624: {
        desc: "下次活动时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            time_list: {
                /** 活动类型 */
                act_type: number;
                /** 开始时间 */
                start_time: number;
                /** 结束时间 */
                end_time: number;
            }[];
        };
    };
    18625: {
        desc: "活动报名时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 报名截止时间 */
            end_time: number;
        };
    };
    18626: {
        desc: "职位变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 职位发生变化 */
            code: number;
        };
    };
    18650: {
        desc: "海域信息2.0";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阵营（东西南北） */
            camp: number;
            /** 工会数量 */
            guild_num: number;
            /** 海域人数 */
            count: number;
            /** 海域战力 */
            fight: number;
            /** 海王id */
            king_id: number;
        };
    };
    18651: {
        desc: "特权";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 特权id */
                priv_id: number;
                /** 剩余次数 */
                residue_num: number;
                /** 状态 0关闭 1开启 */
                status: number;
                /** 持续时间(0一直生效) */
                end_time: number;
                /** 所需爵位 */
                need_job: {
                    /** 爵位id */
                    job_id: number;
                }[];
            }[];
        };
    };
    18652: {
        desc: "操作特权";
        send: (
            number: 18652,
            fmt: "hc",
            args: [
                /**特权id*/
                priv_id: number,
                /**操作 0关闭 1开启*/
                option: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**特权id*/
            priv_id: number,
            /**操作 0关闭 1开启*/
            option: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 特权id */
            priv_id: number;
            /** 状态 0关闭 1开启 */
            status: number;
            /** 持续时间(0一直生效) */
            end_time: number;
        };
    };
    18653: {
        desc: "功勋";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 功勋等级 */
            lv: number;
            /** 功勋值 */
            exploit: number;
        };
    };
    18654: {
        desc: "内政界面";
        send: (
            number: 18654,
            fmt: "hh",
            args: [page_size: number, page_num: number]
        ) => never;
        sendFmt: "hh";
        sendArgs: [page_size: number, page_num: number];
        recv: {
            page_total: number;
            page_size: number;
            page_num: number;
            member: {
                /** vip */
                vip: number;
                /** 角色id */
                role_id: number;
                /**  角色名 */
                role_name: string;
                /** 等级 */
                lv: number;
                /** 职位 */
                job_id: number;
                /** 功勋 */
                exploit: number;
                /** 战力 */
                fight: number;
                /** 工会id */
                guild_id: number;
                /** 工会名 */
                guild_name: string;
            }[];
        };
    };
    18655: {
        desc: "势力分布";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            guild_info: {
                /** 工会num */
                server_num: number;
                /** 工会id */
                guild_id: number;
                /**  工会名称 */
                guild_name: string;
                /** 会长id */
                leader_id: number;
                /**  会长名 */
                leader_name: string;
                /** 战力 */
                fight: number;
                /** 人员数量 */
                member_num: number;
            }[];
        };
    };
    18656: {
        desc: "每日奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 凌晨4点职位id,每日奖励领取计算使用 */
            four_level: number;
        };
    };
}
