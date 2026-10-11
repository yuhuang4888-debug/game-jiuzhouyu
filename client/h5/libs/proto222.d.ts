/** 头衔信息
 */
declare interface ProtoFmtInfo {
    22200: {
        desc: "广播头衔";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家Id */
            player_id: number;
            /** 头衔序号 */
            title_id: number;
        };
    };
    22201: {
        desc: "晋升头衔";
        send: (
            number: 22201,
            fmt: "c",
            args: [
                /**晋升前头衔序号*/
                prev_title_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**晋升前头衔序号*/
            prev_title_id: number
        ];
        recv: {
            /** 晋升结果 */
            promote_result: number;
            /** 成功则是晋升后头衔序号，失败则是失败之前的服务端的序号。 */
            title_id: number;
        };
    };
}
