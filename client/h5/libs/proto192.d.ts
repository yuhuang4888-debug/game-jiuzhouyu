/** 活动托管
 */
declare interface ProtoFmtInfo {
    19201: {
        desc: "已选择托管的活动列表(没托管的不在协议中)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当日获取的托管币 */
            day_coin: number;
            /** 当前托管币 */
            onhook_coin: number;
            activity_list: {
                /** 模块id(与活动日历中的功能id和子id一样) */
                module_id: number;
                /** 子id */
                sub_module: number;
                /** 选择时间，等于0表示未选择托管 */
                select_time: number;
                behaviour_list: {
                    /** 行为id */
                    behaviour_id: number;
                    /** 选择时间，等于0表示未选择 */
                    b_select_time: number;
                }[];
            }[];
        };
    };
    19202: {
        desc: "选择托管";
        send: (
            number: 19202,
            fmt: "hh",
            args: [
                /**模块id*/
                module_id: number,
                /**子id*/
                sub_module: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**模块id*/
            module_id: number,
            /**子id*/
            sub_module: number
        ];
        recv: {
            code: number;
            /** 模块id */
            module_id: number;
            /** 子id */
            sub_module: number;
        };
    };
    19203: {
        desc: "取消托管";
        send: (
            number: 19203,
            fmt: "hh",
            args: [
                /**模块id*/
                module_id: number,
                /**子id*/
                sub_module: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**模块id*/
            module_id: number,
            /**子id*/
            sub_module: number
        ];
        recv: {
            code: number;
            /** 模块id */
            module_id: number;
            /** 子id */
            sub_module: number;
        };
    };
    19204: {
        desc: "选择托管行为";
        send: (
            number: 19204,
            fmt: "hhh",
            args: [
                /**模块id*/
                module_id: number,
                /**子id*/
                sub_module: number,
                behaviour_id: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**模块id*/
            module_id: number,
            /**子id*/
            sub_module: number,
            behaviour_id: number
        ];
        recv: {
            code: number;
            /** 模块id */
            module_id: number;
            /** 子id */
            sub_module: number;
            behaviour_id: number;
        };
    };
    19205: {
        desc: "取消托管行为";
        send: (
            number: 19205,
            fmt: "hhh",
            args: [
                /**模块id*/
                module_id: number,
                /**子id*/
                sub_module: number,
                behaviour_id: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**模块id*/
            module_id: number,
            /**子id*/
            sub_module: number,
            behaviour_id: number
        ];
        recv: {
            code: number;
            /** 模块id */
            module_id: number;
            /** 子id */
            sub_module: number;
            behaviour_id: number;
        };
    };
    19206: {
        desc: "托管记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            record_list: {
                /** 模块id(与活动日历中的功能id和子id一样) */
                module_id: number;
                /** 子id */
                sub_module: number;
                /** 活动托管时间 */
                onhook_time: number;
                /** 托管结果 1:成功，其他待定义 */
                result: number;
                /** 花费了多少托管币 */
                cost_coin: number;
                /** 结束时间 */
                time: number;
            }[];
        };
    };
    19207: {
        desc: "兑换托管币";
        send: (
            number: 19207,
            fmt: "i",
            args: [exchange_onhook_coin: number]
        ) => never;
        sendFmt: "i";
        sendArgs: [exchange_onhook_coin: number];
        recv: {
            code: number;
            /** 当前托管币 */
            onhook_coin: number;
            /** 获得的绑钻 */
            bgold: number;
        };
    };
    19208: {
        desc: "托管币更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当日获取的托管币 */
            day_coin: number;
            /** 当前托管币 */
            onhook_coin: number;
        };
    };
}
