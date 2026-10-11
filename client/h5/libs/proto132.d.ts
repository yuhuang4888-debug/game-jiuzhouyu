/** 玩家离线挂机
 */
declare interface ProtoFmtInfo {
    13211: {
        desc: "离线挂机规则2离线挂机触发[5秒触发一次]";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码##等于1不用显示 */
            error_code: number;
            /** 下次触发时间戳 */
            next_time: number;
            /** 已挂机时间（离线和在线总和） */
            had_afk_time: number;
        };
    };
    13212: {
        desc: "离线挂机登录信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 登录类型##1正常登录,2重连(重连不用显示) */
            login_type: number;
            /** 玩家挂机时等级 */
            off_lv: number;
            /** 消耗的挂机时间 */
            cost_afk_time: number;
            /** 挂机获得的物品列表 */
            goods_list: {
                /** 类型 */
                type: number;
                /** 物品id */
                goods_id: number;
                /** 数量 */
                num: number;
            }[];
            /** 找回的剩余次数 */
            back_count: number;
            /** 找回的剩余经验 */
            back_exp: number;
            /** 玩家剩余挂机时间 */
            afk_time: number;
            /** 下次触发时间戳 */
            next_time: number;
            /** 每分钟的经验效率 */
            exp_effect: number;
            /** 已挂机时间（离线和在线总和） */
            had_afk_time: number;
        };
    };
    13213: {
        desc: "离线挂机赎回";
        send: (
            number: 13213,
            fmt: "i",
            args: [
                /**找回次数*/
                count: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**找回次数*/
            count: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 次数 */
            count: number;
            /** 获得的经验 */
            exp: number;
        };
    };
    13214: {
        desc: "离线挂机信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家剩余挂机时间 */
            afk_time: number;
            /** 下次触发时间戳 */
            next_time: number;
        };
    };
    13215: {
        desc: "升级的经验效率";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 每分钟的经验效率 */
            exp_effect: number;
        };
    };
    13216: {
        desc: "领取挂机累计的奖励|后续推13212";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
            reward: any;
        };
    };
    13217: {
        desc: "经验加成信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 经验加成列表 */
            exp_list: {
                /** 类型 */
                type: number;
                /** 数量 */
                ratio: number;
                /** 结束时间# 当 ratio 不等于0 时， 该值等于表示永久 */
                end_time: number;
            }[];
        };
    };
}
