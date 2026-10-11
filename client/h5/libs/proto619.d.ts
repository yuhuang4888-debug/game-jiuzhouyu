/** pk记录
 */
declare interface ProtoFmtInfo {
    61900: {
        desc: "界面协议";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            send_list: {
                /** 0击杀，1被杀 */
                sign: number;
                /** 时间 */
                time: number;
                /** 地点（场景名） */
                scene_name: string;
                /** 击杀者被击杀者名字 */
                attr_name: string;
                /** 击杀者被击杀者id */
                attr_id: number;
            }[];
            kf_send_list: {
                /** 0击杀，1被杀 */
                sign: number;
                /** 时间 */
                time: number;
                /** 地点（场景名） */
                scene_name: string;
                /** 击杀者被击杀者服务器id */
                server_id: number;
                /** 击杀者被击杀者服务器数量 */
                server_num: number;
                c_server_msg: string;
                /** 击杀者被击杀者名字 */
                attr_name: string;
                /** 击杀者被击杀者id */
                attr_id: number;
            }[];
        };
    };
    61901: {
        desc: "新记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0击杀，1被杀 */
            sign: number;
            /** 时间 */
            time: number;
            /** 地点（场景名） */
            scene_name: string;
            /** 击杀者被击杀者名字 */
            attr_name: string;
            /** 击杀者被击杀者id */
            attr_id: number;
        };
    };
    61902: {
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0击杀，1被杀 */
            sign: number;
            /** 时间 */
            time: number;
            /** 地点（场景名） */
            scene_name: string;
            /** 击杀者被击杀者服务器id */
            server_id: number;
            /** 击杀者被击杀者服务器数量 */
            server_num: number;
            c_server_msg: string;
            /** 击杀者被击杀者名字 */
            attr_name: string;
            /** 击杀者被击杀者id */
            attr_id: number;
        };
    };
}
