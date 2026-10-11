/** 圣裁
 */
declare interface ProtoFmtInfo {
    13901: {
        desc: "圣裁列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            weapon_list: {
                weapon_id: number;
                lv: number;
                /** 当前武器激活的积分值 */
                score: number;
                /** 0 没佩戴 1 佩戴中 */
                state: number;
            }[];
            /** 由于目前只有一个武器是用转盘加积分的，这个列表只有一个 */
            loop_list: {
                /** 武器id */
                weapon_id: number;
                /** 已经转的次数 */
                loop_times: number;
                /** 操作时间 */
                utime: number;
            }[];
        };
    };
    13902: {
        desc: "激活/升级";
        send: (
            number: 13902,
            fmt: "i",
            args: [
                /**武器id*/
                weapon_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**武器id*/
            weapon_id: number
        ];
        recv: {
            code: number;
            /** 武器id */
            weapon_id: number;
            lv: number;
            /** 0 没佩戴 1 佩戴中 */
            state: number;
        };
    };
    13903: {
        desc: "停止转盘，获取转盘结果";
        send: (
            number: 13903,
            fmt: "i",
            args: [
                /**武器id*/
                weapon_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**武器id*/
            weapon_id: number
        ];
        recv: {
            code: number;
            /** 转出的号码 */
            no: number;
            /** 增加的积分 */
            score_add: number;
            /** 武器id */
            weapon_id: number;
        };
    };
    13904: {
        desc: "转盘结算";
        send: (
            number: 13904,
            fmt: "i",
            args: [
                /**武器id*/
                weapon_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**武器id*/
            weapon_id: number
        ];
        recv: {
            code: number;
            /** 转出的号码 */
            no: number;
            /** 增加的积分 */
            score_add: number;
            /** 武器id */
            weapon_id: number;
            lv: number;
            /** 当前武器激活的积分值 */
            score: number;
            /** 0 没佩戴 1 佩戴中 */
            state: number;
            /** 已经转的次数 */
            loop_times: number;
            /** 操作时间 */
            utime: number;
        };
    };
    13905: {
        desc: "佩戴";
        send: (
            number: 13905,
            fmt: "i",
            args: [
                /**武器id*/
                weapon_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**武器id*/
            weapon_id: number
        ];
        recv: {
            code: number;
            /** 武器id */
            weapon_id: number;
            /** 0 没佩戴 1 佩戴中 */
            state: number;
        };
    };
}
