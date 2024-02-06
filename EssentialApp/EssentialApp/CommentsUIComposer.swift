//
// Copyright © Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
	private init() {}

	private typealias ImageCommentPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentsAdapter>

	public static func commentsComposedWith(
		commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>
	) -> ListViewController {
		let presentationAdapter = ImageCommentPresentationAdapter(loader: commentsLoader)

		let imageCommentController = makeImageCommentViewController(title: ImageCommentsPresenter.title)
		imageCommentController.onRefresh = presentationAdapter.loadResource

		presentationAdapter.presenter = LoadResourcePresenter(
			resourceView: CommentsAdapter(controller: imageCommentController),
			loadingView: WeakRefVirtualProxy(imageCommentController),
			errorView: WeakRefVirtualProxy(imageCommentController),
			mapper: { ImageCommentsPresenter.map($0) })

		return imageCommentController
	}

	private static func makeImageCommentViewController(title: String) -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let commentsController = storyboard.instantiateInitialViewController() as! ListViewController
		commentsController.title = title
		return commentsController
	}
}
