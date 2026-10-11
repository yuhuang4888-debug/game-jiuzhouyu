/** 怪物图鉴
 */
declare interface ProtoFmtInfo {
    44201: {
        desc: "打开界面展示列表";
        send: (
            number: 44201,
            fmt: "h",
            args: [
                /**图鉴类型*/
                type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**图鉴类型*/
            type: number
        ];
        recv: {
            /** 图鉴类型 */
            type: number;
            /** 已激活组合 */
            group_list: {
                /** 组合id */
                group_id: number;
                /** 组合等级 */
                lv: number;
            }[];
            /** 已合成图鉴 */
            pic_list: {
                /** 图鉴id */
                pic_id: number;
                /** 等级 */
                lv: number;
            }[];
        };
    };
    44202: {
        desc: "激活";
        send: (
            number: 44202,
            fmt: "i",
            args: [
                /**图鉴id*/
                pic_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**图鉴id*/
            pic_id: number
        ];
        recv: {
            /** 错误码（1成功） */
            errcode: number;
            /** 图鉴id */
            pic_id: number;
        };
    };
    44203: {
        desc: "升级";
        send: (
            number: 44203,
            fmt: "i",
            args: [
                /**图鉴id*/
                pic_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**图鉴id*/
            pic_id: number
        ];
        recv: {
            /** 错误码（1成功） */
            errcode: number;
            /** 图鉴id */
            pic_id: number;
            /** 当前等级 */
            lv: number;
        };
    };
    44204: {
        desc: "激活组合";
        send: (
            number: 44204,
            fmt: "i",
            args: [
                /**组合id*/
                group_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**组合id*/
            group_id: number
        ];
        recv: {
            /** 错误码（1成功） */
            errcode: number;
            /** 组合id */
            group_id: number;
            /** 当前等级 */
            lv: number;
        };
    };
    44205: {
        desc: "待分解图鉴列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 已合成图鉴 */
            pic_list: {
                /** 图鉴id */
                pic_id: number;
            }[];
        };
    };
}
