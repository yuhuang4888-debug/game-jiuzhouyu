/** 冒险之书
 */
declare interface ProtoFmtInfo {
    42500: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
            /**  参数 */
            args: string;
        };
    };
    42501: {
        desc: "已达成未激活的冒险之书";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 书本类型 */
                type: number;
                /** 书本子类型 */
                subtype: number;
            }[];
        };
    };
    42502: {
        desc: "冒险之书列表";
        send: (
            number: 42502,
            fmt: "c",
            args: [
                /**书本类型*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**书本类型*/
            type: number
        ];
        recv: {
            /** 书本类型 */
            type: number;
            /** 只发有进度的数据 */
            book_list: {
                /** 书本子类型 */
                subtype: number;
                /** 进度 */
                progress: number;
                /** 奖励状态 0: 进行中 1: 已达成可激活 2: 已激活 */
                status: number;
            }[];
        };
    };
    42503: {
        desc: "激活书本";
        send: (
            number: 42503,
            fmt: "cc",
            args: [
                /**书本类型*/
                type: number,
                /**书本子类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**书本类型*/
            type: number,
            /**书本子类型*/
            subtype: number
        ];
        recv: {
            error_code: number;
            /** 书本类型 */
            type: number;
            /** 书本子类型 */
            subtype: number;
        };
    };
    42504: {
        desc: "状态更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            update_list: {
                /** 书本类型 */
                type: number;
                /** 书本子类型 */
                subtype: number;
                /** 进度 */
                progress: number;
                /** 奖励状态 0: 进行中 1: 已达成可激活 2: 已激活 */
                status: number;
            }[];
        };
    };
}
