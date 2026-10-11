/** 钻石大战
 */
declare interface ProtoFmtInfo {
    13700: {
        desc: "活动状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0未开放 1报名期间 2准备期间 3海选期间 4排位赛期间 5已结束 */
            war_state: number;
            /** 结束时间戳 */
            end_time: number;
        };
    };
    13701: {
        desc: "面板信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0未报名 1已报名 */
            is_sign: number;
        };
    };
    13702: {
        desc: "报名";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    13703: {
        desc: "入场倒计时";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前轮次 */
            action: number;
            /** 1海选开始倒计时;2入战斗场倒计时;3打斗开始倒计时;4成功晋级倒计时;5争霸战开始倒计时;6打斗结束倒计时 */
            type: number;
            /** 倒计时结束时间戳 */
            end_time: number;
        };
    };
    13704: {
        desc: "进入准备场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    13705: {
        desc: "小面板";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否已淘汰 0否 1是 */
            is_out: number;
            /** 战区 */
            zone: number;
            /** 参与的最后赛段 拿去读配置算获得元宝(1-8为海选，8以上是16强) */
            stage: number;
            /** 胜场数 */
            win_num: number;
            /** 负场数 */
            lose_num: number;
            /** 命数 */
            life_num: number;
        };
    };
    13706: {
        desc: "购买命数";
        send: (
            number: 13706,
            fmt: "c",
            args: [
                /**数量*/
                num: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**数量*/
            num: number
        ];
        recv: {
            code: number;
            /** 命数 */
            life_num: number;
        };
    };
    13707: {
        desc: "退出场景";
        send: (
            number: 13707,
            fmt: "c",
            args: [
                /**0退出准备 1退出场景*/
                quit: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0退出准备 1退出场景*/
            quit: number
        ];
        recv: {
            code: number;
        };
    };
    13708: {
        desc: "战报";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否结算 0不是 1是 */
            settlement: number;
            /** 1胜利 2负 3超时得胜 4轮空得胜 5只剩一人冠军 6超时得负 */
            result: number;
            /** 当前场次 */
            action_id: number;
        };
    };
    13709: {
        desc: "激活AI暂时不用";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    13710: {
        desc: "命数信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己的 */
            self_life: number;
            /** 对方的 */
            other_life: number;
        };
    };
    13711: {
        desc: "战报";
        send: (
            number: 13711,
            fmt: "c",
            args: [
                /**期号*/
                war_no: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**期号*/
            war_no: number
        ];
        recv: {
            /** 期号 */
            war_no: number;
            list: {
                /** 战区 */
                zone: number;
                /** 名次 */
                rank: number;
                /** 玩家id */
                role_id: number;
                /** 服务器id */
                server_id: number;
                /**  服务器信息 */
                c_server_msg: string;
                /**  平台 */
                platform: string;
                /** 平台id */
                platform_id: number;
                /**  玩家名 */
                role_name: string;
                /**  公会名 */
                guild_name: string;
                /** vip等级 */
                vip: number;
                /** 战力 */
                power: number;
                /** 职业 */
                career: number;
            }[];
        };
    };
    13712: {
        desc: "冠军广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 战区 */
            zone: number;
            /**  玩家 */
            role_name: string;
        };
    };
    13714: {
        desc: "假人信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            power: number;
            server_id: number;
            server_num: number;
            server_name: string;
            c_server_msg: string;
        };
    };
    13715: {
        desc: "使用技能";
        send: (number: 13715, fmt: "i", args: [skill_id: number]) => never;
        sendFmt: "i";
        sendArgs: [skill_id: number];
        recv: {
            code: number;
            skill_id: number;
            cd_end_time: number;
        };
    };
    13716: {
        desc: "赛区";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            zone: number;
        };
    };
    13718: {
        desc: "竞猜面板更新(客户端收到协议后，如果竞猜面板打开中，请求13719更新面板信息)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            end_time: number;
            /** 1 更新 */
            update: number;
        };
    };
    13719: {
        desc: "竞猜面板";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            end_time: number;
            list: {
                /** 场次 */
                action_id: number;
                list3: {
                    /** 竞猜玩家 */
                    suprid: number;
                    /** A玩家id */
                    arid: number;
                    /** A玩家服id */
                    asid: number;
                    /** A玩家服数 */
                    asnum: number;
                    /**  A服信息 */
                    acsmsg: string;
                    /**  a玩家名 */
                    aname: string;
                    /**  a玩家头像 */
                    apic: string;
                    apicver: number;
                    /** a玩家等级 */
                    alv: number;
                    /** a玩家职业 */
                    acareer: number;
                    /** a玩家战力 */
                    apower: number;
                    /** b玩家id */
                    brid: number;
                    /** B玩家服id */
                    bsid: number;
                    /** B玩家服数 */
                    bsnum: number;
                    /**  B服信息 */
                    bcsmsg: string;
                    /**  b玩家名 */
                    bname: string;
                    /**  b玩家头像 */
                    bpic: string;
                    bpicver: number;
                    /** b玩家等级 */
                    blv: number;
                    /** b玩家职业 */
                    bcareer: number;
                    /** b玩家战力 */
                    bpower: number;
                    /** 胜者id */
                    winner: number;
                }[];
            }[];
        };
    };
    13720: {
        desc: "竞猜";
        send: (
            number: 13720,
            fmt: "clc",
            args: [
                /**竞猜类型*/
                guess_type: number,
                role_id: number,
                /**场次*/
                action_id: number
            ]
        ) => never;
        sendFmt: "clc";
        sendArgs: [
            /**竞猜类型*/
            guess_type: number,
            role_id: number,
            /**场次*/
            action_id: number
        ];
        recv: {
            code: number;
            role_id: number;
            action_id: number;
        };
    };
    13721: {
        desc: "所有的竞猜记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 战域 */
                zone: number;
                /** 场次 */
                action: number;
                /** 玩家支持的选手id */
                suprid: number;
                /** 竞猜类型 */
                guess_type: number;
                /** 奖励状态 0 未获取 1 已获取 */
                reward_st: number;
                /** 胜利者 0表示没出结果 winner = arid 或者 winner = brid */
                winner: number;
                /** A玩家id */
                arid: number;
                /** A 服务器id */
                asid: number;
                /** A 服务器数trunkcodedocproto_auto137钻石大战.cs:268 */
                asnum: number;
                /**  A服信息 */
                acsmsg: string;
                aname: string;
                alv: number;
                asex: number;
                acareer: number;
                /**  A头像 */
                apic: string;
                /** A头像版本 */
                apicver: number;
                /** A战力 */
                apower: number;
                brid: number;
                bsid: number;
                bsnum: number;
                /**  B服信息 */
                bcsmsg: string;
                bname: string;
                blv: number;
                bsex: number;
                bcareer: number;
                bpic: string;
                bpicver: number;
                bpower: number;
            }[];
        };
    };
    13722: {
        desc: "添加新竞猜记录(服务端推)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 战域 */
            zone: number;
            /** 场次 */
            action: number;
            /** 玩家支持的选手id */
            suprid: number;
            /** 竞猜类型 */
            guess_type: number;
            /** 奖励状态 0 未获取 1 已获取 */
            reward_st: number;
            /** 胜利者 0表示没出结果 winner = arid 或者 winner = brid */
            winner: number;
            /** A玩家id */
            arid: number;
            /** A 服务器id */
            asid: number;
            /** A 服务器数 */
            asnum: number;
            aname: string;
            alv: number;
            asex: number;
            acareer: number;
            /**  A头像 */
            apic: string;
            /** A头像版本 */
            apicver: number;
            /** A战力 */
            apower: number;
            brid: number;
            bsid: number;
            bsnum: number;
            bname: string;
            blv: number;
            bsex: number;
            bcareer: number;
            bpic: string;
            bpicver: number;
            bpower: number;
        };
    };
    13723: {
        desc: "竞猜奖励领取";
        send: (
            number: 13723,
            fmt: "ccl",
            args: [
                /**战域*/
                zone: number,
                /**场次*/
                action: number,
                /**玩家支持的选手id*/
                suprid: number
            ]
        ) => never;
        sendFmt: "ccl";
        sendArgs: [
            /**战域*/
            zone: number,
            /**场次*/
            action: number,
            /**玩家支持的选手id*/
            suprid: number
        ];
        recv: {
            code: number;
            /** 战域 */
            zone: number;
            /** 场次 */
            action: number;
            /** 玩家支持的选手id */
            suprid: number;
            /** 竞猜类型 */
            guess_type: number;
            /** 奖励状态 0 未获取 1 已获取 */
            reward_st: number;
        };
    };
    13724: {
        desc: "胜者广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 区域 */
            zone: number;
            /** 场次 */
            action: number;
            /** 胜者玩家id */
            winner: number;
        };
    };
}
