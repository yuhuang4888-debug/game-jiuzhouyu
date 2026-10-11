/** 龙珠
 */
declare interface ProtoFmtInfo {
    14300: {
        desc: "获取龙珠列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 龙珠列表（未激活的龙珠不发 */
            dragon_list: {
                /** 龙珠Id */
                dragon_id: number;
                /** 龙珠等级 */
                dragon_lv: number;
                /** 战力 */
                power: number;
                /** 下一级期望战力 */
                next_power: number;
            }[];
        };
    };
    14301: {
        desc: "激活龙珠";
        send: (
            number: 14301,
            fmt: "i",
            args: [
                /**龙珠Id*/
                dragon_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**龙珠Id*/
            dragon_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 龙珠Id */
            dragon_id: number;
            /** 战力 */
            power: number;
            /** 下一级期望战力 */
            next_power: number;
        };
    };
    14302: {
        desc: "升级龙珠";
        send: (
            number: 14302,
            fmt: "i",
            args: [
                /**龙珠Id*/
                dragon_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**龙珠Id*/
            dragon_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 龙珠Id */
            dragon_id: number;
            /** 龙珠等级 */
            dragon_lv: number;
            /** 战力 */
            power: number;
            /** 下一级期望战力 */
            next_power: number;
        };
    };
    14303: {
        desc: "龙珠套装列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前穿着的套装类型 */
            wear_type: number;
            /** 激活的套装列表 */
            figure_list: {
                /** 套装类型 */
                type: number;
                /** 套装等级 */
                lv: number;
                /** 战力 */
                power: number;
                /** 下一级期望战力 */
                next_power: number;
            }[];
        };
    };
    14304: {
        desc: "穿戴、脱下龙珠套装";
        send: (
            number: 14304,
            fmt: "cc",
            args: [
                /**套装类型*/
                type: number,
                /**操作类型 1: 穿戴 2: 脱下*/
                op: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**套装类型*/
            type: number,
            /**操作类型 1: 穿戴 2: 脱下*/
            op: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            type: number;
            op: number;
        };
    };
    14305: {
        desc: "激活龙珠套装";
        send: (
            number: 14305,
            fmt: "cc",
            args: [
                /**套装类型*/
                type: number,
                /**套装等级*/
                lv: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**套装类型*/
            type: number,
            /**套装等级*/
            lv: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            type: number;
            lv: number;
        };
    };
    14306: {
        desc: "龙珠系统总战力";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            total_power: number;
        };
    };
    14310: {
        desc: "龙珠雕像总览";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 雕像激活状态 0：未激活 1：已激活 */
            status: number;
            /** 雕像激活加成战力（已激活时为0） */
            power: number;
        };
    };
    14311: {
        desc: "星核直购购买信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 礼包id */
            id: number;
            /** 购买次数 */
            buy_times: number;
        };
    };
    14312: {
        desc: "星核直购购买奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward: {
                good_type: number;
                good_id: number;
                num: number;
            }[];
        };
    };
}
