/** 我要变强
 */
declare interface ProtoFmtInfo {
    61801: {
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            state_list: {
                id: number;
                /** 状态 0未完成 1已完成 */
                state: number;
                /** 未完成发0，否则发时间戳 */
                time: number;
            }[];
        };
    };
}
