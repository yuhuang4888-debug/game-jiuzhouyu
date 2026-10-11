/** 勋章
 */
declare interface ProtoFmtInfo {
    13400: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    13401: {
        desc: "获取勋章信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 勋章等级id */
            id: number;
            /** 强化等级 */
            stren_lv: number;
            /** 强化经验 */
            stren_exp: number;
            /** 当前声望值 */
            honour: number;
            /** 当前战力 */
            power: number;
        };
    };
    13402: {
        desc: "晋升";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 升级后的id */
            id: number;
            /** 当前声望值 */
            honour: number;
        };
    };
    13403: {
        desc: "头衔升级/激活";
        send: (
            number: 13403,
            fmt: "i",
            args: [
                /**头衔id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**头衔id*/
            id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 头衔id */
            id: number;
            /** 当前等级 */
            level: number;
            /** 头衔战力 */
            power: number;
            /** 是否佩戴 0未激活 1已激活未佩戴 2佩戴中 */
            is_equip: number;
        };
    };
    13404: {
        desc: "头衔佩戴";
        send: (
            number: 13404,
            fmt: "i",
            args: [
                /**头衔id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**头衔id*/
            id: number
        ];
        recv: {
            /** 头衔id */
            id: number;
            /** 返回码 */
            code: number;
        };
    };
    13405: {
        desc: "头衔界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 头衔id */
                id: number;
                /** 头衔等级 */
                level: number;
                /** 头衔战力 */
                power: number;
                /** 是否佩戴 0未激活 1已激活未佩戴 2佩戴中 */
                is_equip: number;
            }[];
        };
    };
    13406: {
        desc: "头衔卸下";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    13407: {
        desc: "强化";
        send: (number: 13407, fmt: any, args: [cost_list: any]) => never;
        sendFmt: any;
        sendArgs: [cost_list: any];
        recv: {
            lv: number;
            exp: number;
            power: number;
        };
    };
}
