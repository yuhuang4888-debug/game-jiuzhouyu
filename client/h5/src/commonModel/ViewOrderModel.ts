import { EventName } from '../common/EventName';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventDispatcher } from '../util/EventDispatcher';
import { TMap } from '../util/TMap';

export enum EnumViewOrder {
    /**离线挂架 */
    eOutLine = 1,
    /**守护过期 */
    eGuardExpired,
    /**活动上线提醒界面 */

}

export class ViewOrderModelEvent {
    static className: string = "ViewOrderModelEvent";

    static PROTO_OUT_LINE: string = 'PROTO_OUT_LINE_' + ViewOrderModelEvent.className;
}

export class ViewOrderModel extends EventDispatcher {
    private static _instance: ViewOrderModel;
    public static GetInstance() {
        if (!ViewOrderModel._instance) {
            ViewOrderModel._instance = new ViewOrderModel();
        }
        return ViewOrderModel._instance;
    }

    private _viewList: TMap<EnumViewOrder, any>;


    public constructor() {
        super();
        this._viewList = new TMap<EnumViewOrder, any>();
    }


    public GetTypeByView(type: EnumViewOrder) {
        return this._viewList.get(type);
    }


    public SetTypeByView(type: EnumViewOrder, view: any) {
        this._viewList.set(type, view);
    }


    public OpenNextTypeView(type: EnumViewOrder) {
        for (const key in this._viewList.keys) {
            if (Object.prototype.hasOwnProperty.call(this._viewList.keys, key)) {
                let k: number = +this._viewList.keys[key];
                let value = this._viewList.get(k);
                if (value && (k > type)) {
                    // let view_class: any = window[value.view.viewName];.
                    // let view = new view_class();
                    // if (value?.arg) {
                    //     view.Open(value.arg);
                    // } else {
                    //     view.Open();
                    // }
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, value.viewName, value?.arg);
                    this._viewList.set(k, null);
                    break;
                }
            }
        }
    }


}

window['ViewOrderModel'] = ViewOrderModel;
