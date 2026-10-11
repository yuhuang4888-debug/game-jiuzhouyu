/** 精灵转盘
 */
declare interface ProtoFmtInfo {
    50901: {
        desc: "获取祝福值";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            bless_value: number;
        };
    };
    50902: {
        desc: "转盘";
        send: (
            number: 50902,
            fmt: "cc",
            args: [
                /**1 普通 2 高级*/
                type: number,
                /**次数*/
                count: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**1 普通 2 高级*/
            type: number,
            /**次数*/
            count: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 1 普通 2 高级 */
            type: number;
            /** 次数 */
            count: number;
            bless_value: number;
            reward_list: any;
        };
    };
}
