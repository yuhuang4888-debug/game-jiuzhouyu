/** 免战保护
 */
declare interface ProtoFmtInfo {
    20201: {
        desc: "免战保护信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            protect_list: {
                /** 场景类型 */
                scene_type: number;
                /** 总保护时间 */
                protect_time: number;
                /** 使用次数 */
                use_count: number;
            }[];
        };
    };
    20202: {
        desc: "使用保护";
        send: (
            number: 20202,
            fmt: "i",
            args: [
                /**场景类型*/
                scene_type: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**场景类型*/
            scene_type: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 场景类型 */
            scene_type: number;
            /** 总保护时间 */
            protect_time: number;
            /** 使用次数 */
            use_count: number;
        };
    };
    20203: {
        desc: "保护结束时间(进入场景请求)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 结束时间 */
            end_time: number;
        };
    };
    20204: {
        desc: "保护时间更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 场景类型 */
            scene_type: number;
            /** 总保护时间 */
            protect_time: number;
            /** 使用次数 */
            use_count: number;
        };
    };
    20205: {
        desc: "结束保护";
        send: (
            number: 20205,
            fmt: "i",
            args: [
                /**场景类型*/
                scene_type: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**场景类型*/
            scene_type: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 场景类型 */
            scene_type: number;
        };
    };
}
