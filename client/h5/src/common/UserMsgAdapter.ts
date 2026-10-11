import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName, LoginStateEvent } from "./EventName"
import { AppConst } from "./AppConst"
import { HttpUtil } from "../util/HttpUtil"
import { Util, GlobalTimerQuest } from "../util/Util"
import { GameError } from "../util/GameError"
import { FigureProtoVo } from "./FigureProtoVo"
import { CommonGoodsListVo } from "./CommonGoodsListVo"
import { BaseAttrProtoVo } from "./BaseAttrProtoVo"
import { LogManager } from "./LogManager"
import { SpecialCharKey } from "./SpecialCharKey"
// import { LoginManager } from "../login/LoginManager"
// import { Message } from "../sysInfo/SysInfoController"
/*
    格式化字符串说明:
    i:  32位无符号整数
    I:  32位有符号整数
    h:  16位无符号整数
    H:  16位有符号整数
    c:  8位无符号整数
    C:  8位有符号整数
    l:  64位无符号整数
    L:  64位有符号整数
    s:  字符串
*/
let local_LogManager = LogManager
export class UserMsgAdapter {
    static Instance: UserMsgAdapter

    socket: Laya.Socket
    receive_byteBuff: Laya.Byte = new Laya.Byte()
    send_byteBuff: Laya.Byte
    register_list: {
        [key: number]: Function
    } = {}

    write_cache_cmd = 0
    write_cache_fmt_str = ""
    write_cache_value_list = {}
    write_cache_count = 0
    result_list: Array<any> = []
    write_cmd = 0
    
    cmd_callback_queue = [] //协议callback队列
    curr_frame_receive_count = 0
    cmd_handler_time = null
    last_handler_time = null
    last_connect_time = 0 //上一次连接的时间
    curr_read_length = 0
    
    wait_player_handle = false

    /**
     * 最终连接socket的url
     */
    url_to_connected = ""
    /**
     * 是否已经连接服务器
     */
    is_game_connected = false
    /**
     * 重连次数
     */
    reconnect_times = 0
    /**
     * 重连类型
     */
    reconnect_type
    /**
     * 自动重连次数
     */
    default_auto_connect = 0

    ReadFmt2Func = {
        "c": "readUint8",
        "C": "readByte",
        "h": "readUint16",
        "H": "readInt16",
        "i": "readUint32",
        "I": "readInt32",
        "s": "readUTFString"
    }

    WriteFmt2Func = {
        "c": "writeUint8",
        "C": "writeByte",
        "h": "writeUint16",
        "H": "writeInt16",
        "i": "writeUint32",
        "I": "writeInt32",
        "s": "writeUTFString"
    }
    count_time_id
    connect_timer

    ClientProtocol

    writeStream
    readStream

    alert_view

    cache_byteBuff_list
    cache_byte = true

    public static GetInstance() {
        if (!UserMsgAdapter.Instance) {
            UserMsgAdapter.Instance = new UserMsgAdapter()
        }
        return UserMsgAdapter.Instance
    }

    public constructor() {
        let local_Math = Math,
        value, func_name, hight_value, low_value
        this.readStream = (buffer: Laya.Byte, type) => {
            func_name = this.ReadFmt2Func[type]
            if (func_name) {
                value = buffer[func_name]()
            }
            else if (type == "l") {
                hight_value = buffer.readUint32()
                low_value = buffer.readUint32()
                value = hight_value * local_Math.pow(2, 32) + low_value
            }
            else if (type == "L") {
                hight_value = buffer.readInt32()
                low_value = buffer.readInt32()
                value = hight_value * local_Math.pow(2, 32) + low_value
            }else
            {
                value = null
            }
            return value
        };
        this.writeStream = (buffer: Laya.Byte, type, value) => {
            // console.log("send Message = "+ type+"_"+(value))
            if (value == null) {
                if (type == "s") {
                    value = ""
                }
                else {
                    value = 0
                }
            }
            func_name = this.WriteFmt2Func[type]
            if (func_name) {
                buffer[func_name](value)
            }
            else if (type == "l") {
                hight_value = local_Math.floor(value / local_Math.pow(2, 32))
                low_value = value % local_Math.pow(2, 32)
                buffer.writeUint32(hight_value)
                buffer.writeUint32(low_value)
            }
            else if (type == "L") {
                hight_value = local_Math.floor(value / local_Math.pow(2, 32))
                low_value = value % local_Math.pow(2, 32)
                buffer.writeInt32(hight_value)
                buffer.writeInt32(low_value)
            }
        };
    }

    public InitSocket = () => {
        if (!this.socket){
            this.receive_byteBuff.endian = Laya.Byte.BIG_ENDIAN
            this.socket = new Laya.Socket()
            //设置数据格式为二进制，默认为字符串
            this.socket.endian = Laya.Byte.BIG_ENDIAN
            //添加收到数据侦听，收到数据会调用此方法
            this.socket.on(Laya.Event.MESSAGE, this, this.onReceiveMessage)
            //添加链接打开侦听，连接成功会调用此方法
            this.socket.on(Laya.Event.OPEN, this, this.onSocketOpen)
            //添加链接关闭侦听，手动关闭或者服务器关闭连接会调用此方法
            this.socket.on(Laya.Event.CLOSE, this, this.onSocketClose)
            //添加异常侦听，出现异常会调用此方法
            this.socket.on(Laya.Event.ERROR, this,  this.onSocketError)
        }
    }


    public ReconnectHandler = () => {
        let login_model = window["LoginModel"].GetInstance(),
            login_mgr = window["LoginManager"].GetInstance()
        if(login_model.not_show_reconnect) return

        if(this.default_auto_connect){
            console.log("------静默重连------", this.default_auto_connect)
            this.default_auto_connect --
            let call_func = ()=>{
                login_model.reconnect_on_game = true
                login_mgr.Fire(LoginStateEvent.START_GAME_CONNECT)
            }
            setTimeout(() => {
                this.CheckResUpdate(call_func)
                this.AddConnectCheckTimer()
            }, 2000);
            return
        }

        let ok =()=> {
            this.wait_player_handle = false
            let run = () => {
                login_model.reconnect_on_game = true 
                login_mgr.Fire(LoginStateEvent.START_GAME_CONNECT)
            }
            this.CheckResUpdate(run)
            this.AddConnectCheckTimer()
            login_model.CheckNewNotice()

        }

        let cancel = (close_cancel) => {
            if(close_cancel) return
            this.wait_player_handle = false
            let run = () => {
                login_model.reconnect_on_game = false
                GlobalEventSystem.Fire(EventName.CHANGE_ACCOUNT)
            }
            this.CheckResUpdate(run)
        }
        
        if (this.reconnect_times < 4 ) { 
            this.reconnect_times++
            
            let check_gameout_state = () => {
                if (login_model.IsGameOutState() ) {
                    login_model.ResetGameOutState()
                    this.reconnect_times = 0
                    return true
                }else{
                    return false
                }
            }
            
            if (this.reconnect_times == 4 ) {
                let func =()=> {
                    if (check_gameout_state() ) {
                        return
                    }
                    this.wait_player_handle = true
                    let Alert = window["Alert"], Alert_Type = window["Alert_Type"]
                    let alert_view = Alert.Show("无法重连到服务器，请确认网络后重试", Alert_Type.One, 
                        cancel, 
                        cancel, 
                        "返回登录",
                        null,
                        true
                    )
                    alert_view.click_bg_toClose = false
                    
                    GameError.Instance.SendErrorToPHP("网络可用时重连多次失败")
                }
                GlobalTimerQuest.AddDelayQuest(func,2)
            }else{
                let func =()=> {
                    if (login_model.not_show_reconnect ) {
                        return
                    }
                    if (check_gameout_state()) {
                        return
                    }
                    this.wait_player_handle = true
                    let str = "网络已断开连接"
                    let Alert = window["Alert"], Alert_Type = window["Alert_Type"]
                    let alert_view = Alert.Show(str, Alert_Type.Two, 
                        ok, 
                        cancel, 
                        "重连", 
                        "返回登录",
                        null,
                        true
                    )
                    alert_view.click_bg_toClose = false

                    
                    if (login_model.other_place_login ) {
                        login_model.other_place_login = false
                        return
                    }
                    if (login_model.revice_10006_response_time) {
                        let time = Laya.timer.currTimer * 0.001 - login_model.revice_10006_response_time
                        GameError.Instance.SendErrorToPHP("网络可用时弹出断线重连:" + time + "," + this.reconnect_type + "," + AppConst.SocketAddress + "," + AppConst.SocketPort)
                    }
                }
                GlobalTimerQuest.AddDelayQuest(func,2)
            } 
        }
    }

    public ConnectSocket = () => {
        //连接服务器
        this.InitSocket()

        console.log("---------- try connect server ----------" + AppConst.SocketAddress + " " + AppConst.SocketPort)
        let address = AppConst.SocketAddress
        let is_http = HttpUtil.is_http
        if (window["Util"].IsConch() && window["is_debug"] && Laya.Browser.onAndroid) {
            is_http = true
        }
        if (is_http && address.indexOf("s:") == 0) {
            is_http = false
            address = address.replace("s:", "")
        }
        console.log("---------- http, sslport ----------" + is_http + " " + AppConst.SslSocketPort)
        let login_model = window["LoginModel"].GetInstance()
        let lburl = login_model.Lburl
        if (is_http) {
            if (lburl && lburl != "") {
                this.ConnectByUrl(`wss:${SpecialCharKey.UserMsgAdapter1}${lburl}`)
            }
            else if (AppConst.SocketLburl) {
                this.ConnectByUrl(`ws:${SpecialCharKey.UserMsgAdapter1}${AppConst.SocketLburl}`)
            }
            else {
                if (AppConst.SocketPort && AppConst.SocketPort != -1) {
                    this.ConnectByUrl(`ws:${SpecialCharKey.UserMsgAdapter1}${address}:${AppConst.SocketPort}`)
                }
                else {
                    if (AppConst.SslSocketPort && AppConst.SslSocketPort != -1) {
                        this.ConnectByUrl(`wss:${SpecialCharKey.UserMsgAdapter1}${address}:${AppConst.SslSocketPort}`)
                    }
                    else {
                        this.ConnectByUrl(`wss:${SpecialCharKey.UserMsgAdapter1}${address}`)
                    }
                }
            }
        }
        else {
            if (lburl && lburl != "") {
                this.ConnectByUrl(`wss:${SpecialCharKey.UserMsgAdapter1}${lburl}`)
            }
            else if (AppConst.SocketLburl) {
                this.ConnectByUrl(`wss:${SpecialCharKey.UserMsgAdapter1}${AppConst.SocketLburl}`)
            }
            else {
                if (AppConst.SslSocketPort) {
                    this.ConnectByUrl(`wss:${SpecialCharKey.UserMsgAdapter1}${address}:${AppConst.SslSocketPort}`)
                }
                else {
                    if (AppConst.SocketPort && AppConst.SocketPort != -1) {
                        this.ConnectByUrl(`wss:${SpecialCharKey.UserMsgAdapter1}${address}:${AppConst.SocketPort}`)
                    }
                    else {
                        this.ConnectByUrl(`wss:${SpecialCharKey.UserMsgAdapter1}${address}`)
                    }
                }
            }
        }
    }

    private ConnectByUrl = (url) => {
        this.url_to_connected = url
        this.socket.connectByUrl(url)
    }

    private ReceiveHandler = () => {
        if (!this.is_game_connected || this.receive_byteBuff.length < 4 || this.receive_byteBuff.pos > this.receive_byteBuff.length - 4)
            return
        let len = this.receive_byteBuff.readUint32()
        this.curr_read_length += len
        let cmd: number = this.receive_byteBuff.readUint16(), call_back = this.register_list[cmd]
        this.receive_byteBuff.readByte()//let server_compression = 
        if (local_LogManager.print_log && cmd != 10006 && cmd != 12008 && cmd != 12001) {
            console.log("receive cmd = " + cmd)
        }
        if (call_back) {
            call_back()
        }
        //如果没注册存入缓存内
        else if(this.cache_byte){
            if(!this.cache_byteBuff_list){
                this.cache_byteBuff_list = []
            }
            console.warn("------ReceiveHandler@Cache------", cmd)
            let byte = new Laya.Byte()
            byte.endian = Laya.Byte.BIG_ENDIAN
            byte.clear()
            byte.writeArrayBuffer(this.receive_byteBuff.buffer, this.curr_read_length - len, len)
            byte.pos = 0
            this.cache_byteBuff_list.push(byte)
        }

        if (this.curr_read_length < this.receive_byteBuff.length) {
            this.ReceiveHandler()
        }
    }

    private onReceiveMessage(msg: any = null) {
        // console.log("onReceiveMessage-----------------------------------")
        this.receive_byteBuff.clear()
        this.receive_byteBuff.writeArrayBuffer(msg)
        this.receive_byteBuff.pos = 0
        // this.socket.readBytes(this.receive_byteBuff)
        this.curr_read_length = 0
        this.ReceiveHandler()
    }

    public ReceiveAllCacheMessage(){
        if(this.cache_byte){
            this.cache_byte = false
            let list = this.cache_byteBuff_list
            if(list){
                for(let byte of this.cache_byteBuff_list){
                    this.onReceiveMessage(byte.buffer)
                }
            }
            this.cache_byteBuff_list = undefined
        }
    }

    private onSocketOpen = () => {
        this.send_byteBuff = this.socket.output
        this.send_byteBuff.endian = Laya.Byte.BIG_ENDIAN
        console.log("onSocketOpen-----------------------------------")
        this.is_game_connected = true
        GlobalEventSystem.Fire(EventName.GAME_CONNECT)
    }

    private onSocketClose = (e) => {
        console.log("onSocketClose-----------------------------------", e)
        if(!this.is_game_connected) return
        this.is_game_connected = false
        this.cmd_callback_queue.length = 0

        let login_model = window["LoginModel"].GetInstance()
        if(login_model.is_back_from_game == false){
            this.reconnect_times = 0
            this.reconnect_type = 4
            if(login_model.other_place_login){
                this.default_auto_connect = 0
            }
            else{
                this.default_auto_connect = 2
            }
            this.ReconnectHandler()
        }
        GlobalEventSystem.Fire(EventName.GAME_DISCONNECT)
    }

    private onSocketError = (e) => {
        console.log("onSocketError-----------------------------------", e)
        if(!this.is_game_connected) return
        this.is_game_connected = false
        this.cmd_callback_queue.length = 0

        let login_model = window["LoginModel"].GetInstance()
        //判断在游戏中进行静默重连
        if(login_model.is_back_from_game == false){
            this.reconnect_type = 1
            this.reconnect_times = 0
            if(login_model.other_place_login){
                this.default_auto_connect = 0
            }
            else{
                this.default_auto_connect = 1
            }
            this.ReconnectHandler()
        }
        //判断从游戏中返回,在选角/创角界面,普通重连
        else if(login_model.is_back_from_game == true){
            this.reconnect_type = 2
            this.reconnect_times = 0

            if(login_model.other_place_login){
                this.default_auto_connect = 0
            }
            else{
                this.default_auto_connect = 1
            }
            this.ReconnectHandler()
        }else{
            this.reconnect_type = 3
        }
        GlobalEventSystem.Fire(EventName.GAME_DISCONNECT)
    }
    
    public IsGameConnected = () => {
        return this.is_game_connected
    }

    // --发送一次性封装好的数据给服务器
    public SendAllFmtToGame = (cmd, fmt_str, other) => {
        this.WriteBegin(cmd)
        this.WriteFMT(fmt_str, other)
        this.SendToGame()
    }

    //每次发送前面有一个16位的协议内容长度 一个16位的 1000 这里先写入32位的1000 然后发送的时候写入协议内容长度
    public WriteBegin = (cmd) => {
        this.send_byteBuff.clear()
        this.send_byteBuff.writeUint32(1000)
        this.send_byteBuff.writeInt16(cmd)
        if (local_LogManager.print_log && cmd != 10006 && cmd != 12001 && cmd) {
            console.log("send cmd =" + cmd)
        }
        this.write_cmd = cmd ? cmd : 0
    }

    public WriteFMT = (fmt_str: string, other) => {
        if (fmt_str) {
            let args_list = other, buffer: Laya.Byte = this.send_byteBuff
            for (let i = 0; i < fmt_str.length; i++) {
                this.writeStream(buffer, fmt_str.charAt(i), args_list[i])
            }
        }
    }
    
    public SendToGame = () => {
        if(this.socket && this.socket.connected){
            this.send_byteBuff.pos = 0
            this.send_byteBuff.writeInt16(this.send_byteBuff.length)
            // this.socket.send(this.send_byteBuff)//, this.send_byteBuff.bytesAvailable
            this.socket.flush()
        }
    }

    public ReadFmt = (fmt_str: string) => {
        let buffer = this.receive_byteBuff
        let len = fmt_str.length
        if (len == 1) {
            return this.readStream(buffer, fmt_str)
        }
        else {
            for (let i = 0; i < len; i++) {
                this.result_list[i] = this.readStream(buffer, fmt_str.charAt(i))
            }
            this.result_list.length = len
            return this.result_list //this.result_list.slice(0, len)
        }
    }

    public RegisterMsgOperate = (id, register_func) => {
        this.register_list[id] = register_func
    }

    //主动关闭socket 不需要弹重连
    public CloseSocket = () => {
        console.log("------CloseSocket------")
        if (this.socket) {
            this.is_game_connected = false
            this.socket.off(Laya.Event.MESSAGE, this, this.onReceiveMessage)
            this.socket.off(Laya.Event.OPEN, this, this.onSocketOpen)
            this.socket.off(Laya.Event.CLOSE, this, this.onSocketClose)
            this.socket.off(Laya.Event.ERROR, this, this.onSocketError)
            if(this.socket.connected)
            {
                this.socket.close()
            } 
            this.socket = null
        }
    }

    // //重连弹窗定时器
    // private StartReconnectTimer() {
    //     console.log("StartReconnectTimer++++++++++++++++++")
    //     this.CancelReconnectTimer()
    //     this.count_time_id = GlobalTimerQuest.AddPeriodQuest(() =>
    //     {
    //         this.OnTime()
    //     }, 4000)
    // }

    // public OnTime() {
    //     if (this.count_time_id) {
    //         this.ReconnectHandler(true)
    //     }
    // }

    // public CancelReconnectTimer() {
    //     console.log("CancelReconnectTimer++++++++++++++++++++")
    //     if (this.count_time_id) {
    //         GlobalTimerQuest.CancelQuest(this.count_time_id)
    //         this.count_time_id = undefined
    //         if (this.alert_view && this.alert_view.HasOpen()) {
    //             this.alert_view.Close()
    //             this.alert_view = null
    //         }
    //     }
    // }

    public GetSCMD = <P extends Proto>(scmdId: P, not_read?): ProtoRecvVObj<P> => {
        let cfg = this.ClientProtocol //ResManager.GetInstance().GetResByUrl()  //
        if (cfg && cfg[scmdId]) {
            let scmdCfg = cfg[scmdId]
            let scmd: any = {}
            for (let key in scmdCfg) {
                this.ReadScmd(scmdCfg[key], key, scmd, not_read)
            }
            return scmd
        }
        else {
            GameError.GetInstance().SendErrorToPHP(`Not Find PROTO ${scmdId}`, false)
        }
        return false
    }

    public ReadScmd = (cfg, key, scmd, not_read?) => {
        if (typeof cfg == "string") {
            if (not_read) {
                scmd[`${key}`] = {}
            }
            else {
                switch (cfg) {
                    case "RecFigure":
                        scmd[`${key}`] = (new FigureProtoVo()).ReadFmt(scmd)
                        break
                    case "ObjectList":
                        scmd[`${key}`] = (new CommonGoodsListVo()).ReadFmt(scmd)
                        break
                    case "RecAttr":
                        scmd[`${key}`] = (new BaseAttrProtoVo()).ReadFmt(scmd)
                        break
                    case "AttrList":
                        scmd[`${key}`] = this.ReadAttrArr()
                        break
                    default:
                        scmd[`${key}`] = this.ReadFmt(cfg)
                        break
                }
            }
        }
        else if (Array.isArray(cfg)) {
            scmd[`${key}`] = []
            if (!not_read) {
                let len = this.ReadFmt("h")
                for (let i = 0; i < len; i++) {
                    let p = {}
                    for (let key1 in cfg[0]) {
                        this.ReadScmd(cfg[0][key1], key1, p)
                    }
                    scmd[`${key}`].push(p)
                }
            }
        }
    }

    public ReadAttrArr() {
        let len = this.ReadFmt("h")
        let attrArr = []
        for (let i = 0; i < len; i++) {
            attrArr.push([this.ReadFmt("h"), this.ReadFmt("i")])
        }
        return attrArr
    }

    public CheckResUpdate(call){
        let call_state = false
        let call_back = () =>{
            if(!call_state){
                call_state = true
                call()
            }
        }

        let back_func = (state) =>{
            if(state){
                call_state = true
                let exit_func = () =>{

                }
                let desc = "您好，检查到游戏有新的版本更新，建议您退出游戏后重新登录。"
                let Alert = window["Alert"], Alert_Type = window["Alert_Type"]
                let alert_view = Alert.Show(desc, Alert_Type.One, exit_func, null, "确定", null ,null , true)
                alert_view.click_bg_toClose = false
                this.wait_player_handle = true
            }
            call_back()
        }
        this.CheckRemoteResChange(back_func)

        setTimeout(() => {
            call_back()
        }, 2000);
    }

    public CheckRemoteResChange(back_func){
        back_func()
        // console.warn("------CheckRemoteResChange------")
        // let call_func = () =>[

        // ]
        // let url = ""
        //HttpUtil.HttpGetRequest(url, {}, call_func)
    }

    public AddConnectCheckTimer(){ 
        this.RemoveConnectCheckTimer()
        let time = 0
        let login_model = window["LoginModel"].GetInstance()
        let onTimer = ()=> {
            time++
            if (time >= 15 || this.is_game_connected || (login_model.is_back_from_game && !login_model.account_data_10000)) {
                this.RemoveConnectCheckTimer()
                if (time >= 15 && ! this.is_game_connected ) {
                    // window["Message"].show("重连失败")
                    console.log("------ConnectCheck :静默重连失败 ------")
                    this.ReconnectHandler()
                }
                return
            }
        }
        this.connect_timer = GlobalTimerQuest.AddPeriodQuest(onTimer,1,-1)
    }
    
    public RemoveConnectCheckTimer(){ 
        
        if (this.connect_timer ) {
            GlobalTimerQuest.CancelQuest(this.connect_timer)
            this.connect_timer = null
        }
    }
}

window["UserMsgAdapter"] = UserMsgAdapter