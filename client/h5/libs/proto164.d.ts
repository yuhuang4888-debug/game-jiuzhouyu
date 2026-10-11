/** 天命觉醒
 */
declare interface ProtoFmtInfo {
    16400: {
        desc: "天命觉醒界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            active_ids: {
                /** 已经点亮的命格id */
                active_id: number;
            }[];
        };
    };
    16401: {
        desc: "点亮命格";
        send: (
            number: 16401,
            fmt: "i",
            args: [
                /**命格id*/
                cell_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**命格id*/
            cell_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 命格id */
            cell_id: number;
        };
    };
}
