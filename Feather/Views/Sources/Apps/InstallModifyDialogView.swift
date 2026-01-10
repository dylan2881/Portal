import SwiftUI
import NimbleViews

// MARK: - Modern Install/Modify Dialog
struct InstallModifyDialogView: View {
	@Environment(\.dismiss) var dismiss
	let app: AppInfoPresentable
	
	@State private var showInstallPreview = false
	
	var body: some View {
		NavigationView {
			ZStack {
				// Modern gradient background
				LinearGradient(
					colors: [
						Color.green.opacity(0.08),
						Color.green.opacity(0.03),
						Color(.systemBackground)
					],
					startPoint: .topLeading,
					endPoint: .bottomTrailing
				)
				.ignoresSafeArea()
				
				VStack(spacing: 0) {
					// Success icon and message
					VStack(spacing: 24) {
						// Animated success icon
						ZStack {
							Circle()
								.fill(
									LinearGradient(
										colors: [Color.green.opacity(0.15), Color.green.opacity(0.08)],
										startPoint: .topLeading,
										endPoint: .bottomTrailing
									)
								)
								.frame(width: 120, height: 120)
								.overlay(
									Circle()
										.stroke(
											LinearGradient(
												colors: [Color.green.opacity(0.4), Color.green.opacity(0.1)],
												startPoint: .topLeading,
												endPoint: .bottomTrailing
											),
											lineWidth: 3
										)
								)
							
							Image(systemName: "checkmark")
								.font(.system(size: 50, weight: .bold))
								.foregroundStyle(Color.green)
						}
						.shadow(color: Color.green.opacity(0.3), radius: 20, x: 0, y: 8)
						
						VStack(spacing: 10) {
							Text("Download Complete")
								.font(.system(size: 26, weight: .bold, design: .rounded))
								.foregroundStyle(.primary)
							
							Text("Choose what to do with \(app.name ?? "this app")")
								.font(.system(size: 15, weight: .medium))
								.foregroundStyle(.secondary)
								.multilineTextAlignment(.center)
								.padding(.horizontal, 30)
						}
					}
					.padding(.top, 50)
					.padding(.bottom, 30)
				
				// App info card
				appInfoCard
					.padding(.horizontal, 20)
					.padding(.bottom, 30)
				
					// Action buttons
					VStack(spacing: 14) {
						// Sign & Install button
						Button {
							dismiss()
							// Trigger signing and installation
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
								showInstallPreview = true
							}
						} label: {
							HStack(spacing: 12) {
								Image(systemName: "checkmark.seal.fill")
									.font(.system(size: 18, weight: .bold))
								Text("Sign & Install")
									.font(.system(size: 18, weight: .bold))
							}
							.foregroundStyle(.white)
							.frame(maxWidth: .infinity)
							.padding(.vertical, 18)
							.background(
								LinearGradient(
									colors: [Color.green, Color.green.opacity(0.85)],
									startPoint: .leading,
									endPoint: .trailing
								)
							)
							.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
							.shadow(color: Color.green.opacity(0.4), radius: 12, x: 0, y: 6)
						}
						
						// Modify button
						Button {
							dismiss()
							// Open signing view for modification
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
								NotificationCenter.default.post(
									name: Notification.Name("Feather.openSigningView"),
									object: app
								)
							}
						} label: {
							HStack(spacing: 12) {
								Image(systemName: "slider.horizontal.3")
									.font(.system(size: 18, weight: .bold))
								Text("Modify")
									.font(.system(size: 18, weight: .bold))
							}
							.foregroundStyle(.white)
							.frame(maxWidth: .infinity)
							.padding(.vertical, 18)
							.background(
								LinearGradient(
									colors: [Color.accentColor, Color.accentColor.opacity(0.85)],
									startPoint: .leading,
									endPoint: .trailing
								)
							)
							.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
							.shadow(color: Color.accentColor.opacity(0.4), radius: 12, x: 0, y: 6)
						}
						
						// Cancel button
						Button {
							dismiss()
						} label: {
							Text("Cancel")
								.font(.system(size: 17, weight: .semibold))
								.foregroundStyle(.secondary)
								.frame(maxWidth: .infinity)
								.padding(.vertical, 16)
								.background(
									RoundedRectangle(cornerRadius: 16, style: .continuous)
										.fill(Color(UIColor.tertiarySystemGroupedBackground))
								)
						}
					}
					.padding(.horizontal, 24)
					.padding(.bottom, 30)
					
					Spacer()
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarHidden(true)
		}
		.sheet(isPresented: $showInstallPreview) {
			InstallPreviewView(app: app, isSharing: false, fromLibraryTab: false)
		}
	}
	
	// MARK: - App Info Card
	@ViewBuilder
	private var appInfoCard: some View {
		HStack(spacing: 12) {
			// App icon
			if let iconURL = (app as? Signed)?.iconURL ?? (app as? Imported)?.iconURL {
				AsyncImage(url: iconURL) { phase in
					switch phase {
					case .empty:
						iconPlaceholder
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: 50, height: 50)
							.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
					case .failure:
						iconPlaceholder
					@unknown default:
						iconPlaceholder
					}
				}
			} else {
				iconPlaceholder
			}
			
			// App info
			VStack(alignment: .leading, spacing: 4) {
				Text(app.name ?? "Unknown")
					.font(.system(size: 16, weight: .semibold))
					.foregroundStyle(.primary)
				
				if let version = app.version {
					Text("Version \(version)")
						.font(.system(size: 13))
						.foregroundStyle(.secondary)
				}
				
				if let identifier = app.identifier {
					Text(identifier)
						.font(.system(size: 11))
						.foregroundStyle(.tertiary)
						.lineLimit(1)
				}
			}
			
			Spacer()
		}
		.padding(18)
		.background(
			ZStack {
				RoundedRectangle(cornerRadius: 18, style: .continuous)
					.fill(Color(.secondarySystemGroupedBackground))
				
				RoundedRectangle(cornerRadius: 18, style: .continuous)
					.stroke(
						LinearGradient(
							colors: [Color.green.opacity(0.3), Color.green.opacity(0.1)],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						),
						lineWidth: 2
					)
			}
		)
		.shadow(color: Color.green.opacity(0.15), radius: 12, x: 0, y: 6)
	}
	
	private var iconPlaceholder: some View {
		RoundedRectangle(cornerRadius: 12, style: .continuous)
			.fill(Color.secondary.opacity(0.2))
			.frame(width: 50, height: 50)
			.overlay(
				Image(systemName: "app.fill")
					.font(.system(size: 22))
					.foregroundStyle(.secondary)
			)
	}
}
