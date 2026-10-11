/** 等级活动
 */
declare interface ProtoFmtInfo {
    61200: {
        desc: "界面协议";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 活动类型 */
                type: number;
                /** 活动子类型 */
                subtype: number;
                /** 结束时间戳 */
                end_time: number;
                grade_state: {
                    /** 档次 */
                    grade: number;
                    /** 状态 */
                    state: number;
                }[];
                /**  活动条件 */
                act_condition: string;
            }[];
        };
    };
    61201: {
        desc: "购买";
        send: (
            number: 61201,
            fmt: "hhh",
            args: [
                /**类型*/
                type: number,
                /**子类型*/
                subtype: number,
                /**档次*/
                grade: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**类型*/
            type: number,
            /**子类型*/
            subtype: number,
            /**档次*/
            grade: number
        ];
        recv: {
            /** 类型 */
            type: number;
            /** 子类型 */
            subtype: number;
            /** 档次 */
            grade: number;
            /** 返回码 */
            code: number;
        };
    };
    61202: {
        desc: "活动配置数据";
        send: (
            number: 61202,
            fmt: "hh",
            args: [
                /**类型*/
                type: number,
                /**子类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**类型*/
            type: number,
            /**子类型*/
            subtype: number
        ];
        recv: {
            /** 类型 */
            type: number;
            /** 子类型 */
            subtype: number;
            /**  名字 */
            act_name: string;
            /** 开启等级 */
            open_lv: number;
            /** 持续时间等级抢购：单位天，助力礼包：单位小时 */
            continue_time: number;
            /**  条件 */
            condition: string;
            /** 活动开关 */
            circuit: number;
            /** 清理类型 */
            clear_type: number;
        };
    };
    61203: {
        desc: "活动奖励配置数据";
        send: (
            number: 61203,
            fmt: "hhh",
            args: [
                /**类型*/
                type: number,
                /**子类型*/
                subtype: number,
                /**档次 档次为0表示发所有数据，助力礼包为0发空（数据太多）*/
                grade: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**类型*/
            type: number,
            /**子类型*/
            subtype: number,
            /**档次 档次为0表示发所有数据，助力礼包为0发空（数据太多）*/
            grade: number
        ];
        recv: {
            /** 类型 */
            type: number;
            /** 子类型 */
            subtype: number;
            grade_cfg: {
                /** 档次 */
                grade: number;
                /**  原价 没有发[] */
                normal_cost: string;
                /**  现价 */
                cost: string;
                /**  资源 */
                show: string;
                /**  页签文字 */
                page_string: string;
                /**  奖励 */
                reward: string;
                /**  奖励条件 */
                condition: string;
                /** 充值id 没有发0 */
                recharge_id: number;
                /** 折扣 没有发0 */
                discount: number;
            }[];
        };
    };
}
