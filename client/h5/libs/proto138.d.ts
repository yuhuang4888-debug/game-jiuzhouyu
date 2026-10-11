/** 功能开放预告
 */
declare interface ProtoFmtInfo {
    13800: {
        desc: "已完成列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                id: number;
                /** 0 未领取 1已弹幕 2 已领取 */
                state: number;
            }[];
        };
    };
    13801: {
        desc: "领取奖励";
        send: (
            number: 13801,
            fmt: "hc",
            args: [
                id: number,
                /**1弹幕 2 领取*/
                state: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            id: number,
            /**1弹幕 2 领取*/
            state: number
        ];
        recv: {
            code: number;
            id: number;
            state: number;
        };
    };
    13802: {
        desc: "新功能开放";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                id: number;
            }[];
        };
    };
}
