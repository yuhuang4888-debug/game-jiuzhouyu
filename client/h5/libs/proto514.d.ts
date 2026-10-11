/** 虚空秘境
 */
declare interface ProtoFmtInfo {
    51400: {
        desc: "活动信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 结束时间 */
            end_time: number;
            rewards: {
                /** 特权奖励id */
                id: number;
                /** 领取状态 0未领取，1已领取 */
                state: number;
            }[];
        };
    };
    51401: {
        desc: "特权奖励领取";
        send: (
            number: 51401,
            fmt: "i",
            args: [
                /**特权奖励id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**特权奖励id*/
            id: number
        ];
        recv: {
            /** 特权奖励id */
            id: number;
            /** 领取状态 0未领取，1已领取 */
            state: number;
            /** 错误码 */
            errcode: number;
        };
    };
    51402: {
        desc: "特权设置";
        send: (
            number: 51402,
            fmt: "hhc",
            args: [
                /**特权奖励id*/
                id: number,
                /**类型*/
                type: number,
                /**状态 0不勾选 1勾选*/
                state: number
            ]
        ) => never;
        sendFmt: "hhc";
        sendArgs: [
            /**特权奖励id*/
            id: number,
            /**类型*/
            type: number,
            /**状态 0不勾选 1勾选*/
            state: number
        ];
        recv: {
            /** 特权奖励id */
            id: number;
            /** 类型 */
            type: number;
            /** 状态 0不勾选 1勾选 */
            state: number;
            /** 错误码 */
            errcode: number;
        };
    };
}
