/** 打坐信息
 */
declare interface ProtoFmtInfo {
    13100: {
        desc: "打坐操作";
        send: (
            number: 13100,
            fmt: "c",
            args: [
                /**打坐操作：0取消打坐，1打坐*/
                sit_down: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**打坐操作：0取消打坐，1打坐*/
            sit_down: number
        ];
        recv: {
            /** 玩家id */
            player_id: number;
            /** 打坐状态：0取消打坐，1打坐 */
            sit_down: number;
        };
    };
    13102: {
        desc: "回复血量";
        send: (
            number: 13102,
            fmt: "c",
            args: [
                /**回复类型：1打坐回复，2主城安全区，3非主城安全区*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**回复类型：1打坐回复，2主城安全区，3非主城安全区*/
            type: number
        ];
        recv: {
            /** 返回码 */
            res: number;
        };
    };
}
