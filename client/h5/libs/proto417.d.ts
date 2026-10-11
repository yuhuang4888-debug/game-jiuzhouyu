/** 福利
 */
declare interface ProtoFmtInfo {
    41700: {
        desc: "获取礼包状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            giftbag_state: {
                /** 礼包等级 */
                lv: number;
                /** 领取状态 0:未领取 1可领取 2 已领取 3 已过期 4 已被领完 */
                received: number;
                /** 礼包到期时间戳 */
                end_time: number;
                /** 礼包剩余数量 */
                remain_num: number;
            }[];
        };
    };
    41701: {
        desc: "领取等级礼包";
        send: (
            number: 41701,
            fmt: "h",
            args: [
                /**礼包等级*/
                lv: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**礼包等级*/
            lv: number
        ];
        recv: {
            /** 礼包等级 */
            lv: number;
            /** 错误码 */
            code: number;
            rewads: any;
        };
    };
    41702: {
        desc: "领取版本礼包";
        send: (
            number: 41702,
            fmt: "i",
            args: [
                /**版本号*/
                version_code: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**版本号*/
            version_code: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 版本号 */
            version_code: number;
        };
    };
    41703: {
        desc: "获取每日签到状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 累计签到天数 */
            total_days: number;
            /** 累计签到类型id */
            total_type: number;
            /** 累计签到状态 */
            total_state: {
                /** 天数 */
                sum: number;
                /** 领取奖励 0 未领取 1 已领取 3 可领取 */
                receive: number;
            }[];
            /** 每日签到记录 */
            acc_state: {
                /** 当月签到日 */
                check_day: number;
                /** 领取状态 0 未领取 1 已领取 2 可补签 3 可领取 4 vip升级后可领取 5 今天已签到 */
                receive: number;
            }[];
            /** 每日签到类型id */
            check_type: number;
            /** 当月补签次数 */
            retro_times: number;
            /** 当前日期（1-30号） */
            days_fresh: number;
            /** 剩余补签次数 */
            remain_times: number;
            /** 当天签到的日期（天数） */
            check_day: number;
        };
    };
    41704: {
        desc: "领取每日签到奖励";
        send: (
            number: 41704,
            fmt: "cc",
            args: [
                /**天数*/
                day: number,
                /**补签 0 正常签到 1 补签*/
                retroactive: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**天数*/
            day: number,
            /**补签 0 正常签到 1 补签*/
            retroactive: number
        ];
        recv: {
            /** 返回码 1 成功 */
            code: number;
            /** 成功才会返回奖励列表，否则为[] */
            rewads: {
                style: number;
                typeId: number;
                count: number;
            }[];
            /** vip额外奖励 */
            extra_rewads: {
                style: number;
                typeId: number;
                count: number;
            }[];
        };
    };
    41705: {
        desc: "领取累计签到奖励";
        send: (
            number: 41705,
            fmt: "c",
            args: [
                /**天数*/
                day: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**天数*/
            day: number
        ];
        recv: {
            /** 返回码 1 成功 */
            code: number;
            rewads: {
                style: number;
                typeId: number;
                count: number;
            }[];
        };
    };
    41706: {
        desc: "版本礼包领取状态";
        send: (
            number: 41706,
            fmt: "i",
            args: [
                /**版本号*/
                version_code: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**版本号*/
            version_code: number
        ];
        recv: {
            /** 0不可领 1可领 2已领 */
            code: number;
        };
    };
    41707: {
        desc: "下载礼包领取状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0不可领 1可领 2已领 */
            code: number;
            rewads: any;
        };
    };
    41708: {
        desc: "下载礼包领取";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 1 成功 其它为错误码 */
            code: number;
        };
    };
    41710: {
        desc: "分享有礼状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家分享次数 */
            times: number;
            /** 0:未分享 1:已分享未领取奖励 2:已经领取奖励 */
            status: number;
            /** 下次领奖时间戳 */
            next_time: number;
            rewads: any;
        };
    };
    41711: {
        desc: "分享成功";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 1 成功 */
            code: number;
        };
    };
    41712: {
        desc: "分享有礼奖励领取";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 1 成功 */
            code: number;
        };
    };
    41713: {
        desc: "夜间福利领取状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 1 成功 */
            code: number;
            /** 0:不可领 1：可领 2：已领 */
            state: number;
        };
    };
    41714: {
        desc: "夜间福利领取";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 1 成功 */
            code: number;
            state: number;
        };
    };
    41715: {
        desc: "在线福利界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 在线时长(s) */
            time: number;
            /** 本次登陆时间 */
            login_time: number;
            list: {
                /** 奖励id */
                id: number;
                /** 0未达成  2已领取 */
                state: number;
            }[];
        };
    };
    41716: {
        desc: "领取在线福利";
        send: (
            number: 41716,
            fmt: "i",
            args: [
                /**id 0表示一键领取*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**id 0表示一键领取*/
            id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            send_list: {
                /** id */
                reward_id: number;
                rewards: any;
                other_rewards: any;
            }[];
        };
    };
    41717: {
        desc: "等级礼包";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 礼包等级 */
            lv: number;
            /** 礼包已领取的数量 */
            remain_num: number;
        };
    };
    41718: {
        desc: "手机/身份验证";
        send: (
            number: 41718,
            fmt: "slc",
            args: [
                /**名字*/
                name: string,
                /**身份证号码手机号*/
                number: number,
                /**0身份证验证 1手机号验证*/
                type: number
            ]
        ) => never;
        sendFmt: "slc";
        sendArgs: [
            /**名字*/
            name: string,
            /**身份证号码手机号*/
            number: number,
            /**0身份证验证 1手机号验证*/
            type: number
        ];
        recv: {
            /** 0身份证验证 1手机号验证 */
            type: number;
            /** 返回码 */
            code: number;
            reward: any;
        };
    };
    41719: {
        desc: "领取心悦礼包";
        send: (
            number: 41719,
            fmt: "c",
            args: [
                /**1 查看礼包状态 2 领取 策划要热更新功能，新加 3新手礼包状态 4领取新手礼包*/
                opr: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1 查看礼包状态 2 领取 策划要热更新功能，新加 3新手礼包状态 4领取新手礼包*/
            opr: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            opr: number;
            /** 礼包状态 */
            gift_st: number;
            reward: any;
        };
    };
    41720: {
        desc: "获取成长福利任务进度";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            task_list: {
                /** 任务ID */
                task_id: number;
                /** 任务进度 */
                process: number;
                /** 任务状态 0不可领取， 1可领取， 2已领取 | （服务端这边不判断天数，客户端需要自己读配置限制，只有领取时判断） */
                status: number;
            }[];
        };
    };
    41721: {
        desc: "成长福利任务进度更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            task_list: {
                /** 任务ID */
                task_id: number;
                /** 任务进度 */
                process: number;
                /** 任务状态 0不可领取， 1可领取， 2已领取 */
                status: number;
            }[];
        };
    };
    41722: {
        desc: "成长福利任务领取";
        send: (number: 41722, fmt: "h", args: [task_id: number]) => never;
        sendFmt: "h";
        sendArgs: [task_id: number];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 任务ID */
            task_id: number;
            /** 任务状态 0不可领取， 1可领取， 2已领取 */
            status: number;
        };
    };
    41723: {
        desc: "战力福利界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前轮数 */
            round: number;
            /** 可抽奖的次数 */
            times: number;
            /** 历史最高战力 */
            combat: number;
            /** 下一级需要达标的战力 */
            next_combat: number;
            list: {
                /** 该轮已抽到的奖励ID */
                reward_id: number;
            }[];
        };
    };
    41724: {
        desc: "战力福利抽奖";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 1 成功 */
            code: number;
            /** 当前轮数 */
            round: number;
            /** 可抽奖的次数 */
            times: number;
            /** 抽到的奖励ID */
            reward_id: number;
            /** 下一级需要达标的战力 */
            next_combat: number;
        };
    };
}
