<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<jsp:useBean id="dateValue" class="java.util.Date"></jsp:useBean>
<c:set var="active" value="attach" scope="request"></c:set>
<c:set var="title" value="文件 管理" scope="request"></c:set>
<c:import url="/WEB-INF/templates/admin/header.jsp"></c:import>
<link
	href="/Blog/resources/static/admin/plugins/dropzone/4.3.0/min/dropzone.min.css"
	rel="stylesheet">
<style>
#dropzone {
	margin-bottom: 3rem;
}

.dropzone {
	border: 2px dashed #0087F7;
	border-radius: 5px;
	background: white;
}

.dropzone .dz-message {
	font-weight: 400;
}

.dropzone .dz-message .note {
	font-size: 0.8em;
	font-weight: 200;
	display: block;
	margin-top: 1.4rem;
}

.attach-img {
	width: 100px;
	height: 100px;
	border-radius: 10px;
	box-shadow: 0px 0px 8px #333;
}

.attach-text {
	font-size: 12px;
	font-weight: 300;
}

.attach-img:hover {
	background-color: #f9f9f9;
}
</style>
<div class="row">
	<div class="col-sm-12">
		<h4 class="page-title">文件管理</h4>
	</div>
	<div class="row">
		<div class="col-md-12 portlets">
			<!-- Your awesome content goes here -->
			<div class="m-b-30">
				<form action="#" class="dropzone" id="dropzone">
					<div class="fallback">
						<input name="file" type="file" multiple="multiple">
					</div>
					<div class="dz-message">
						<!-- $...{attach_url} -->
						<p>将文件拖至此处或点击上传.本地服务器</p>
						<p>
							<span style="font-size: 16px; color: #d0d0d0;">一次最多可以上传10个文件</span>
						</p>
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="col-md-12 attach">
		<c:if test="${attachs == null || attachs.size() == 0}">
			<div class="row">
				<div class="col-md-4 text-center">
					<div class="alert alert-warning">目前还没有一个附件呢，你可以上传试试!</div>
				</div>
			</div>
		</c:if>

		<c:if test="${attachs !=null && attachs.size() > 0}">
			<c:forEach items="${attachs}" var="attach">
				<div class="col-md-2 text-center m-t-10">
					<jsp:setProperty property="time" name="dateValue" value="${attach.created}"/>
					<fmt:formatDate value="${dateValue}" pattern="yyyy/MM/" var="mouthly_url"/>
					<c:if
							test="${attach.ftype == 'image'}">
							<c:set var="image_url"
								value="${attach_url}${mouthly_url}${attach.fkey}"></c:set>
						</c:if> <c:if test="${attach.ftype != 'image'}">
							<c:set var="image_url"
								value="/Blog/resources/static/admin/images/attach.png"></c:set>
						</c:if>
					<a href="${attach_url}${mouthly_url}${attach.fkey}" target="_blank"> 
					 <img class="attach-img" src="${image_url}" title="${attach.fname}" />
						<!-- 原本是title -->
					</a>
					<div class="clearfix m-t-10">
						<!-- $--{substr(attach.fname, 12)} -->
						<span class="attach-text" data-toggle="tooltip"
							data-placement="top" data-original-title="${attach.fname}">${attach.fname}</span>
					</div>
					<div class="clearfix">
						<button url="${attach_url}${mouthly_url}${attach.fkey}" type="button"
							class="btn btn-warning btn-sm waves-effect waves-light m-t-5 copy">
							<i class="fa fa-copy"></i> <span>复制</span>
						</button>
						<button type="button"
							class="btn btn-danger btn-sm waves-effect waves-light m-t-5"
							onclick="delAttach(${attach.id});">
							<i class="fa fa-trash-o"></i> <span>删除</span>
						</button>
					</div>
				</div>
			</c:forEach>
			<div class="clearfix"></div>
			<ul class="pagination m-b-5 pull-right" >
				<c:if test="${page.present > 1}">
					<li><a href="?page=${page.present - 1}" aria-label="Previous">
							<i class="fa fa-angle-left"></i>&nbsp;上一页
					</a></li>
				</c:if>
				<c:forEach begin="${page.begin}" end="${page.end}" var="num"
					step="1">
					<li class="<c:if test="${page.present == num}">active</c:if>"><a
						href="?page=${num}">${num}</a>
				</c:forEach>
				<c:if test="${page.present < page.end}">
					<li><a href="?page=${page.present + 1}" aria-label="Next">
							下一页&nbsp;<i class="fa fa-angle-right"></i>
					</a></li>
				</c:if>
				<li><span>共${page.end}页</span></li>
			</ul>
		</c:if>
	</div>
</div>

<c:import url="/WEB-INF/templates/admin/footer.jsp"></c:import>

<script
	src="/Blog/resources/static/admin/plugins/dropzone/4.3.0/min/dropzone.min.js"></script>
<script
	src="/Blog/resources/static/admin/plugins/clipboard.js/1.6.0/clipboard.min.js"></script>

<script type="text/javascript">

    var tale = new $.tale();

    $("#dropzone").dropzone({
        url: "/Blog/admin/attach/upload",
        filesizeBase:1024,//定义字节算法 默认1000
        maxFiles: 10,//最大文件数量$.constant().MAX_FILES
        maxFilesize: '${max_file_size}', //MB
        fallback:function(){
            tale.alertError('暂不支持您的浏览器上传!');
        },
        uploadMultiple: true,
        dictFileTooBig:'您的文件超过'+ '${max_file_size}' +'MB!',
        dictInvalidInputType:'不支持您上传的类型',
        dictMaxFilesExceeded:'您的文件超过'+ 10 +'个!',//$.constant().MAX_FILES
        init: function() {
            this.on('queuecomplete', function (files) {
                tale.alertOkAndReload('上传成功');
            });
            this.on('error', function (a, errorMessage, result) {
                if(!result.success && result.msg){
                    tale.alertError(result.msg || '上传失败');
                }
            });
            this.on('maxfilesreached', function () {
                this.removeAllFiles(true);
                tale.alertWarn('文件数量超出限制');
            });
        }
    });

    var clipboard = new Clipboard('button.copy', {
        text: function (trigger) {
            return $(trigger).attr('url');
        }
    });

    clipboard.on('success', function (e) {
        console.info('Action:', e.action);
        console.info('Text:', e.text);
        console.info('Trigger:', e.trigger);
        e.clearSelection();
    });

    function delAttach(id) {
        tale.alertConfirm({
            title: '确定删除该附件吗?',
            then: function () {
                tale.post({
                    url: '/Blog/admin/attach/delete',
                    data: {id: id},
                    success: function (result) {
                        if (result && result.success) {
                            tale.alertOkAndReload('附件删除成功');
                        } else {
                            tale.alertError(result.msg || '附件删除失败');
                        }
                    }
                });
            }
        });
    }
</script>
</body>
</html>