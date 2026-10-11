/** 灵器
 */
declare interface ProtoFmtInfo {
    18001: {
        desc: "佩戴灵器";
        send: (
            number: 18001,
            fmt: "clc",
            args: [
                /**灵器库id*/
                anima_id: number,
                /**佩戴的物品id*/
                goods_id: number,
                /**佩戴位置*/
                equip_pos: number
            ]
        ) => never;
        sendFmt: "clc";
        sendArgs: [
            /**灵器库id*/
            anima_id: number,
            /**佩戴的物品id*/
            goods_id: number,
            /**佩戴位置*/
            equip_pos: number
        ];
        recv: {
            errcode: number;
            /** 灵器库id */
            anima_id: number;
            /** 佩戴的物品id */
            goods_id: number;
            /** 佩戴位置 */
            equip_pos: number;
            /** 佩戴的物品类型id */
            gtype_id: number;
        };
    };
    18002: {
        desc: "卸下灵器";
        send: (
            number: 18002,
            fmt: "cc",
            args: [
                /**灵器库id*/
                anima_id: number,
                /**佩戴位置*/
                equip_pos: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**灵器库id*/
            anima_id: number,
            /**佩戴位置*/
            equip_pos: number
        ];
        recv: {
            errcode: number;
            /** 灵器库id */
            anima_id: number;
            /** 佩戴的物品id */
            goods_id: number;
            /** 佩戴位置 */
            equip_pos: number;
            /** 佩戴的物品类型id */
            gtype_id: number;
        };
    };
}
