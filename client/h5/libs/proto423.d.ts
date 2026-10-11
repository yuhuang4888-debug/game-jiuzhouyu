/** 天魂信息
 */
declare interface ProtoFmtInfo {
    42300: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /**  参数 */
            args: string;
        };
    };
    42301: {
        desc: "天魂信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            soul_list: {
                /** 天魂Id */
                id: number;
                /** 阶数 */
                stage: number;
                /** 等级 */
                lv: number;
            }[];
        };
    };
    42302: {
        desc: "强化天魂";
        send: (
            number: 42302,
            fmt: "i",
            args: [
                /**天魂Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**天魂Id*/
            id: number
        ];
        recv: {
            /** 天魂Id */
            id: number;
            /** 阶数 */
            stage: number;
            /** 等级 */
            lv: number;
        };
    };
    42303: {
        desc: "升阶天魂";
        send: (
            number: 42303,
            fmt: "i",
            args: [
                /**天魂Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**天魂Id*/
            id: number
        ];
        recv: {
            /** 天魂Id */
            id: number;
            /** 阶数 */
            stage: number;
            /** 等级 */
            lv: number;
        };
    };
    42304: {
        desc: "魂附使用次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 魂附使用次数 */
            counter_list: {
                /** 物品id */
                goods_id: number;
                /** 使用次数 */
                times: number;
                /** 次数限制 */
                times_lim: number;
            }[];
        };
    };
    42305: {
        desc: "使用魂附材料";
        send: (
            number: 42305,
            fmt: "i",
            args: [
                /**物品类型id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**物品类型id*/
            type_id: number
        ];
        recv: {
            /** 物品类型id */
            type_id: number;
        };
    };
    42306: {
        desc: "激活天魂";
        send: (
            number: 42306,
            fmt: "i",
            args: [
                /**天魂Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**天魂Id*/
            id: number
        ];
        recv: {
            /** 天魂Id */
            id: number;
        };
    };
}
