package com.fengjie.json;

import com.fengjie.kit.DateKit;

import lombok.Data;
/**
 * 服务器对于前端需要校验的东西,校验后返回的消息
 * @author 丰杰
 * @param <T>
 */
@Data
public class RestResponse<T> {
	/**
     * 服务器响应数据
     */
    private T payload;

    /**
     * 请求是否成功
     */
    private boolean success;

    /**
     * 错误信息
     */
    private String msg;

    /**
     * 状态码
     * 只有1和-1
     */
    private int code = -1;

    /**
     * 服务器响应时间
     */
    private long timestamp = DateKit.nowUnix();
    
    /**
     * 构造一个RestResponse
     * @return 一个新的RespResponse对象
     */
    public static <T> RestResponse<T> build() {
    	RestResponse<T> response = new RestResponse<>();
    	response.setTimestamp(DateKit.nowUnix());
    	return new RestResponse<>();
    }
    
    /**
     * 成功
     * @return
     */
    public static <T> RestResponse<T> success(){
    	RestResponse<T> build = build();
    	build.setSuccess(true);
    	build.setCode(1);
    	return build;
    }
    
    /**
     * 成功,包含要返回的消息
     * @param payload
     * @return
     */
    public static <T> RestResponse<T> success(T payload){
    	RestResponse<T> build = success();
    	build.setPayload(payload);
    	return build;
    }
    
    /**
     * 失败
     * @return
     */
    public static <T> RestResponse<T> fail(){
    	RestResponse<T> build = build();
    	build.setSuccess(false);
    	return build;
    }
    
    /**
     * 失败,包含要返回的消息
     * @param payload
     * @return
     */
    public static <T> RestResponse<T> fail(T payload){
    	RestResponse<T> build = fail();
    	build.setPayload(payload);
    	return build;
    }

}