/** 活动日历信息信息
 */
declare interface ProtoFmtInfo {
    15700: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    15701: {
        desc: "查询活跃度次数";
        send: (
            number: 15701,
            fmt: "c",
            args: [
                /**活动类型 1：非限时 2 ：限时*/
                act_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**活动类型 1：非限时 2 ：限时*/
            act_type: number
        ];
        recv: {
            act_type: number;
            /** 离线挂机时间 */
            time: number;
            ac_list: {
                /** 模块id */
                module: number;
                /** 模块子id */
                module_sub: number;
                /** 功能子类 */
                ac_sub: number;
                /** 活动现在使用次数 */
                num: number;
                /** 活动参与上限 */
                max_num: number;
                /** 当前活动获得活跃度 */
                live: number;
                /** 模块活跃度上限 */
                max_live: number;
                /** 可以获得的活跃度 */
                can_get_live: number;
                /** 1开启 2关闭 3等级限制 */
                state: number;
            }[];
        };
    };
    15703: {
        desc: "查询活跃度奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前活跃度 */
            live: number;
            /** 活跃上限 */
            live_max: number;
            reward_list: {
                /** 后台配置唯一ID */
                id: number;
                /** 0不可领 1可领取 2已领取 */
                state: number;
            }[];
        };
    };
    15705: {
        desc: "领取奖励";
        send: (
            number: 15705,
            fmt: "i",
            args: [
                /**后台配置唯一ID*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**后台配置唯一ID*/
            id: number
        ];
        recv: {
            errcode: number;
            id: number;
        };
    };
    15706: {
        desc: "活动状态变更(主动推送)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 模块id */
            module: number;
            /** 模块子id */
            module_sub: number;
            /** 活动类型 1：非限时 2 ：限时 */
            act_type: number;
            /** 限时活动：1开启  2关闭  非限时的： 4完成 */
            status: number;
        };
    };
    15709: {
        desc: "玩家活跃度形象";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前等级 */
            lv: number;
            /** 活跃度形象活跃度 */
            liveness: number;
            /** 当前选择形象id */
            id: number;
            /** 0:隐藏 1：显示 */
            display: number;
        };
    };
    15710: {
        desc: "玩家活跃度升级";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
            /** 当前等级 */
            lv: number;
            /** 活跃度 */
            liveness: number;
        };
    };
    15711: {
        desc: "更换活跃度形象";
        send: (
            number: 15711,
            fmt: "i",
            args: [
                /**形象ID*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**形象ID*/
            id: number
        ];
        recv: {
            errcode: number;
            /** 形象ID */
            id: number;
        };
    };
    15712: {
        desc: "更换活跃度形象通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家ID */
            role_id: number;
            /** 形象资源ID */
            figure_id: number;
        };
    };
    15713: {
        desc: "显示隐藏活跃度形象";
        send: (
            number: 15713,
            fmt: "c",
            args: [
                /**0: 隐藏  1：显示*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0: 隐藏  1：显示*/
            type: number
        ];
        recv: {
            errcode: number;
            /** 0: 隐藏  1：显示 */
            type: number;
        };
    };
    15714: {
        desc: "离线挂机时间更新推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 离线挂机时间 */
            time: number;
        };
    };
    15715: {
        desc: "活跃度信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            res_act: {
                /** 活动id */
                act_id: number;
                /** 活动子类 */
                act_sub: number;
                /** 剩余次数 */
                lefttimes: number;
                /** 最大找回次数 */
                backTimes: number;
            }[];
        };
    };
    15716: {
        desc: "活跃度找回";
        send: (
            number: 15716,
            fmt: "ihh",
            args: [
                act_id: number,
                /**活动子类*/
                act_sub: number,
                /**找回次数*/
                times: number
            ]
        ) => never;
        sendFmt: "ihh";
        sendArgs: [
            act_id: number,
            /**活动子类*/
            act_sub: number,
            /**找回次数*/
            times: number
        ];
        recv: {
            /** 活动id */
            act_id: number;
            /** 子Id */
            act_sub: number;
            /** 剩余次数 */
            lefttimes: number;
        };
    };
    15717: {
        desc: "领取活跃度";
        send: (
            number: 15717,
            fmt: "ih",
            args: [
                act_id: number,
                /**活动子类*/
                act_sub: number
            ]
        ) => never;
        sendFmt: "ih";
        sendArgs: [
            act_id: number,
            /**活动子类*/
            act_sub: number
        ];
        recv: {
            /** 活动id */
            act_id: number;
            /** 子Id */
            act_sub: number;
            /** 增加的活跃度数量 */
            add_live: number;
        };
    };
    15718: {
        desc: "报名情况";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            act_list: {
                /** 模块id */
                module: number;
                /** 模块子id */
                module_sub: number;
                /** 功能子类 */
                ac_sub: number;
                /** 0 未报名 1 已报名未领取 2 已领取报名奖励 */
                status: number;
                /** 0 没参与 1 有参与 */
                join: number;
            }[];
        };
    };
    15719: {
        desc: "报名";
        send: (
            number: 15719,
            fmt: "iii",
            args: [
                /**模块id*/
                module: number,
                /**模块子id*/
                module_sub: number,
                /**功能子类*/
                ac_sub: number
            ]
        ) => never;
        sendFmt: "iii";
        sendArgs: [
            /**模块id*/
            module: number,
            /**模块子id*/
            module_sub: number,
            /**功能子类*/
            ac_sub: number
        ];
        recv: {
            /** 操作码 */
            code: number;
            /** 模块id */
            module: number;
            /** 模块子id */
            module_sub: number;
            /** 功能子类 */
            ac_sub: number;
            /** 0 未报名 1 已报名未领取 2 已领取报名奖励 */
            status: number;
            /** 0 没参与 1 有参与 */
            join: number;
        };
    };
    15720: {
        desc: "领取报名奖励(活动结束后)";
        send: (
            number: 15720,
            fmt: "iii",
            args: [
                /**模块id*/
                module: number,
                /**模块子id*/
                module_sub: number,
                /**功能子类*/
                ac_sub: number
            ]
        ) => never;
        sendFmt: "iii";
        sendArgs: [
            /**模块id*/
            module: number,
            /**模块子id*/
            module_sub: number,
            /**功能子类*/
            ac_sub: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 模块id */
            module: number;
            /** 模块子id */
            module_sub: number;
            /** 功能子类 */
            ac_sub: number;
        };
    };
    15721: {
        desc: "限时活动开启提醒";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 关闭 1 开启 */
            is_remind: number;
            act_list: {
                /** 模块id */
                module: number;
                /** 模块子id */
                module_sub: number;
                /** 功能子类 */
                ac_sub: number;
                /** 1开启 2关闭 3等级限制 */
                state: number;
                /** 已开启活动的结束时间; 未开启活动的开启时间 */
                time: number;
                /** 0 未报名 1 已报名未领取 2 已领取报名奖励 */
                sign_state: number;
            }[];
        };
    };
    15722: {
        desc: "限时活动提醒开关";
        send: (
            number: 15722,
            fmt: "c",
            args: [
                /**0 关闭今日提醒*/
                open: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0 关闭今日提醒*/
            open: number
        ];
        recv: null;
    };
}
